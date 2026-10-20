# SiAR daily ET0, precipitation and wind — portable, sanitized CEIGRAM adaptation.
# Requires: httr, jsonlite; SIAR_TOKEN environment variable.
# Station codes are examples; confirm against catalog and availability.
suppressPackageStartupMessages({library(httr);library(jsonlite)})
token<-trimws(Sys.getenv("SIAR_TOKEN"))
if(!nzchar(token)) stop("Set SIAR_TOKEN in your local environment; never commit tokens")
base<-"https://servicio.mapa.gob.es/siarapi/API/V1"
start<-as.Date(Sys.getenv("CLIMATE_START_DATE","2024-01-01"))
end<-as.Date(Sys.getenv("CLIMATE_END_DATE","2025-12-31"))
if(is.na(start)||is.na(end)||end<start) stop("Invalid date range")
output<-Sys.getenv("CLIMATE_OUTPUT_DIR","outputs/siar")
stations<-trimws(strsplit(Sys.getenv("SIAR_STATIONS","SA01,AV01,AV101,AV102"),",",fixed=TRUE)[[1]])
if(!length(stations)||any(!nzchar(stations))) stop("No stations selected")
fetch<-function(path,params=list()){
  resp<-httr::GET(paste0(base,path),query=c(list(token=token),params),httr::timeout(90))
  httr::stop_for_status(resp)
  obj<-jsonlite::fromJSON(httr::content(resp,as="text",encoding="UTF-8"),simplifyVector=FALSE)
  if(!is.null(obj$MensajeRespuesta)&&length(obj$MensajeRespuesta)&&nzchar(as.character(obj$MensajeRespuesta)))
    stop("SiAR API returned an error; inspect request and credentials")
  if(!is.null(obj$Datos)) return(obj$Datos)
  if(!is.null(obj$datos)) return(obj$datos)
  if(is.list(obj)&&is.null(names(obj))) return(obj)
  stop("Unexpected SiAR API response structure")
}
field<-function(x,n){v<-x[[n]];if(is.null(v)||!length(v))return(NA_character_);as.character(v[[1]])}
num<-function(x,n){s<-field(x,n);suppressWarnings(as.numeric(gsub(",",".",s,fixed=TRUE)))}
catalog<-fetch("/Info/ESTACIONES")
codes<-vapply(catalog,field,character(1),"Codigo")
dir.create(output,recursive=TRUE,showWarnings=FALSE)
write.csv(data.frame(station=codes,name=vapply(catalog,field,character(1),"Estacion")),file.path(output,"stations_catalog.csv"),row.names=FALSE)
if(identical(Sys.getenv("SIAR_CATALOG_ONLY"),"1")) quit(save="no")
if(any(!stations %in% codes)) stop("Selected station absent from catalog")
rows<-list()
for(st in stations) for(y in seq(as.integer(format(start,"%Y")),as.integer(format(end,"%Y")))){
  lo<-max(start,as.Date(sprintf("%04d-01-01",y)))
  hi<-min(end,as.Date(sprintf("%04d-12-31",y)))
  data<-fetch("/Datos/Diarios/ESTACION",list(Id=st,FechaInicial=as.character(lo),FechaFinal=as.character(hi),DatosCalculados="true"))
  for(x in data){
    day<-as.Date(substr(field(x,"Fecha"),1,10))
    if(is.na(day)||day<lo||day>hi) next
    rows[[length(rows)+1L]]<-data.frame(station=st,date=day,et0_mm=num(x,"EtPMon"),
      precipitation_mm=num(x,"Precipitacion"),wind_speed_original=num(x,"VelViento"),
      wind_direction_deg=num(x,"DirViento"),wind_max_original=num(x,"VelVientoMax"),
      wind_max_direction_deg=num(x,"DirVientoVelMax"))
  }
}
if(!length(rows)) stop("No records returned; check station selection and date coverage")
out<-do.call(rbind,rows)
if(anyDuplicated(out[c("station","date")])) stop("Duplicate station/day records")
out<-out[order(out$station,out$date),]
write.csv(out,file.path(output,"siar_daily.csv"),row.names=FALSE)
coverage<-do.call(rbind,lapply(stations,function(st){
  expected<-seq(start,end,by="day")
  x<-out[out$station==st,]
  data.frame(station=st,expected_days=length(expected),observed_days=nrow(x),
    missing_dates=sum(!expected %in% x$date),missing_et0=sum(is.na(x$et0_mm)),
    missing_wind=sum(is.na(x$wind_speed_original)))
}))
write.csv(coverage,file.path(output,"siar_coverage.csv"),row.names=FALSE)
message("Review API fields, station metadata, units and missingness before scientific reuse.")
