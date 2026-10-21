# Fully synthetic daily series; no research data.
synthetic_daily <- function() {
  days<-seq(as.Date("2024-01-01"),as.Date("2024-01-07"),by="day")
  data.frame(site="DEMO_SYNTHETIC",date=as.character(c(days[c(1,2,4,5,6,7)],days[4])),
             value=c(10,11,NA,13,14,15,12),stringsAsFactors=FALSE)
}
if(sys.nframe()==0L) {
  args<-commandArgs(trailingOnly=TRUE)
  out<-if(length(args))args[1] else "outputs/synthetic/daily.csv"
  dir.create(dirname(out),recursive=TRUE,showWarnings=FALSE)
  write.csv(synthetic_daily(),out,row.names=FALSE)
  message("Created SYNTHETIC fixture at ",out)
}
