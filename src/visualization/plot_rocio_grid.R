# Schematic grid visualization using SYNTHETIC coordinates, not real ROCIO cells.
# Usage: Rscript src/visualization/plot_rocio_grid.R output.png
args<-commandArgs(trailingOnly=TRUE)
if(length(args)!=1L) stop("Usage: output.png")
set.seed(19)
grid<-expand.grid(lon=seq(-3.85,-3.35,length.out=12),lat=seq(40.55,41.15,length.out=12))
site<-c(lon=-3.638,lat=40.994) # Example Buitrago town-centre approximation
d<-(grid$lat-site["lat"])^2+((grid$lon-site["lon"])*cos(site["lat"]*pi/180))^2
closest<-grid[which.min(d),]
dir.create(dirname(args[1]),recursive=TRUE,showWarnings=FALSE)
png(args[1],width=1000,height=780,res=140)
plot(grid$lon,grid$lat,pch=15,col="#C5DCE0",cex=1.4,asp=1,
     xlab="Illustrative longitude",ylab="Illustrative latitude",
     main="Nearest-grid-cell method (SYNTHETIC grid)")
points(closest$lon,closest$lat,pch=15,col="#166C77",cex=2.1)
points(site["lon"],site["lat"],pch=19,col="#CB4E38",cex=1.5)
segments(site["lon"],site["lat"],closest$lon,closest$lat,lty=2,lwd=2)
legend("topright",legend=c("Synthetic grid cell","Selected synthetic cell","Approximate town point"),
       pch=c(15,15,19),col=c("#C5DCE0","#166C77","#CB4E38"),bty="n")
mtext("Not a ROCIO raster or measured spatial result",side=1,line=4,cex=.8)
dev.off()
