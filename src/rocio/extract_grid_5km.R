# ROCIO 5-km NetCDF grid extraction — portable CEIGRAM workflow adaptation.
# Requires: ncdf4. Usage:
# Rscript src/rocio/extract_grid_5km.R <input.nc> <variable> <output.csv>
# Source files are manually obtained; original datasets are not redistributed.
suppressPackageStartupMessages(library(ncdf4))
args <- commandArgs(trailingOnly=TRUE)
if(length(args)!=3L) stop("Usage: <input.nc> <variable> <output.csv>")
path<-args[1]; variable<-args[2]; output<-args[3]
if(!file.exists(path)) stop("Input NetCDF not found")
sites<-data.frame(site=c("Buitrago_del_Lozoya","Colmenar_Viejo","Aranjuez"),
                  lon=c(-3.638,-3.766,-3.602),lat=c(40.994,40.659,40.032))
nc<-nc_open(path); on.exit(nc_close(nc))
if(!variable %in% names(nc$var)) stop("Variable missing: ",variable)
if(!all(c("lon","lat") %in% names(nc$var))) stop("Requires 2D lon/lat coordinates; inspect grid metadata")
lon<-ncvar_get(nc,"lon");lat<-ncvar_get(nc,"lat")
if(!identical(dim(lon),dim(lat)) || length(dim(lon))!=2L) stop("Expected matching 2D lon/lat grids")
dims<-vapply(nc$var[[variable]]$dim,function(d)d$name,character(1))
spatial<-match(dimnames_dummy<-c("rlon","rlat"),dims)
if(anyNA(spatial)) stop("Expected rlon/rlat dimensions; inspect source file")
td<-grep("time",dims,ignore.case=TRUE)
if(length(td)!=1L) stop("Expected exactly one time dimension")
other<-setdiff(seq_along(dims),c(spatial,td))
if(length(other)&&any(vapply(nc$var[[variable]]$dim[other],function(d)d$len,integer(1))!=1L))
  stop("Unexpected non-singleton dimension: select level explicitly")
time_name<-dims[td]
time_units<-ncatt_get(nc,time_name,"units")
calendar<-ncatt_get(nc,time_name,"calendar")
units<-ncatt_get(nc,variable,"units")
tvals<-nc$dim[[time_name]]$vals
if(!isTRUE(time_units$hasatt)) stop("Time units missing")
if(isTRUE(calendar$hasatt)&&!tolower(as.character(calendar$value)) %in% c("standard","gregorian","proleptic_gregorian"))
  stop("Non-Gregorian calendar: use a CF-aware converter before dating observations")
# Keep raw CF time values; dates are intentionally not guessed.
results<-lapply(seq_len(nrow(sites)),function(i){
  f<-cos(sites$lat[i]*pi/180)
  dist2<-(lat-sites$lat[i])^2+((lon-sites$lon[i])*f)^2
  dist2[!is.finite(dist2)]<-Inf
  if(all(is.infinite(dist2))) stop("No valid grid coordinates")
  ij<-arrayInd(which.min(dist2),dim(lon))
  start<-rep(1L,length(dims));count<-rep(1L,length(dims))
  start[spatial]<-ij;count[td]<--1L
  values<-as.numeric(ncvar_get(nc,variable,start=start,count=count))
  if(length(values)!=length(tvals)) stop("Unexpected time-series length")
  data.frame(site=sites$site[i],variable=variable,time_index=seq_along(tvals),
    cf_time_value=tvals,cf_time_units=as.character(time_units$value),
    calendar=if(isTRUE(calendar$hasatt))as.character(calendar$value) else "unspecified",
    value=values,units=if(isTRUE(units$hasatt))as.character(units$value) else NA_character_,
    cell_lon=lon[ij[1],ij[2]],cell_lat=lat[ij[1],ij[2]],
    approximate_distance_km=sqrt(dist2[ij[1],ij[2]])*111.32)
})
dir.create(dirname(output),recursive=TRUE,showWarnings=FALSE)
write.csv(do.call(rbind,results),output,row.names=FALSE)
message("Exported raw grid values; validate time axis, units, and source coverage.")
