# Base R diagnostic plot from site,date,value CSV; no data bundled.
# Usage: Rscript src/visualization/plot_daily_diagnostics.R input.csv output.png [site]
args<-commandArgs(trailingOnly=TRUE)
if(length(args)<2L || length(args)>3L) stop("Usage: input.csv output.png [site]")
x<-read.csv(args[1],stringsAsFactors=FALSE)
if(!all(c("site","date","value") %in% names(x))) stop("Required columns: site,date,value")
site<-if(length(args)==3L)args[3] else as.character(x$site[1])
x<-x[as.character(x$site)==site,,drop=FALSE]
if(!nrow(x)) stop("No rows for site")
x$date<-as.Date(x$date,format="%Y-%m-%d")
if(anyNA(x$date)) stop("Invalid dates")
if(anyDuplicated(x$date)) stop("Resolve duplicate dates before plotting")
x$value<-as.numeric(x$value)
days<-seq(min(x$date),max(x$date),by="day")
y<-rep(NA_real_,length(days)); y[match(x$date,days)]<-x$value
dir.create(dirname(args[2]),recursive=TRUE,showWarnings=FALSE)
png(args[2],width=1250,height=760,res=140)
op<-par(mfrow=c(2,1),mar=c(4,5,3,2))
plot(days,y,type="l",col="#237A82",lwd=2,xlab="",ylab="Value (source units)",
     main=paste("Daily climate series —",site))
points(days[!is.finite(y)],rep(if(any(is.finite(y))) min(y[is.finite(y)]) else 0,sum(!is.finite(y))),
       pch=4,col="#D95F45",cex=1.1)
plot(days,as.integer(!is.finite(y)),type="h",lwd=3,col="#D95F45",
     xlab="Date",ylab="Missing (1=yes)",ylim=c(0,1.1),main="Missing-value / missing-date indicator")
par(op);dev.off()
