args = commandArgs(trailingOnly=TRUE)

outf <- args[1]

for(i in args[2:length(args)])
{
	df <- read.table(i, sep="\t", header=TRUE)

	nm <- strsplit(i, "_points")

	onm <- nm[[1]][1]

	slines <- split(df, df$HitID)

	ln <- length(slines)

	prcMin <- min(df$Perc)
	prcMx <- 100 - prcMin

	mxx <- 0
	mxy <- max(df$Depth)

	colfunc <- colorRampPalette(c(rgb(0,1,0.2,0.7), rgb(1,0,0.2,0.7)))

	for(j in 1:ln)
	{
		if(slines[[j]]$Reverse[1] == 1)
		{
			slines[[j]]$Depth <- rev(slines[[j]]$Depth)
		}

		ty <- (length(slines[[j]]$Depth) * 10) + slines[[j]]$TsStart[1]

		mxx <- pmax(ty, mxx)
	}
	pdf(paste(outf, "/", onm, "_chart.pdf",sep=""), height=5, width=8)
	layout(matrix(1:2,ncol=2), width = c(4,1),height = c(1,1))
	par(mar=c(5.1, 4.1,4.1, 1))
	plot(0,0,col=rgb(0,0,0,0), xlim=c(0,mxx), ylim=c(0,mxy), xlab="Length of Transcript (bp)", ylab="Genomic Read Depth (DNASeq)", main=paste(onm, " pileup-map", sep=""))
	grid()
	for(j in 1:ln)
	{
		prc <- (slines[[j]]$Perc[1]) - prcMin

		cl <- rgb(1-(prc/prcMx), prc/prcMx, 0.2,0.4)

		ln2 <- length(slines[[j]]$TsStart)

		xs <- seq(slines[[j]]$TsStart[1], (ln2*10) + slines[[j]]$TsStart[1] + 10, 10)

		xs <- xs[1:length(slines[[j]]$Depth)]

		points(xs, slines[[j]]$Depth, type="l", col=cl, lwd=2)
	}
	legend_image <- as.raster(matrix(colfunc(20), ncol=1))
	par(mar=c(3, 1,3, 2.1), cex=0.6)
	plot(c(0,2),c(-1,2),type = 'n', axes = F,xlab = '', ylab = '')
	text(x=1.1, y = seq(0.02,0.98,l=5), labels = seq(prcMin,100,l=5))
	text(0.8,1.2, labels="Alignment Identites")
	rasterImage(legend_image, 0, 0, 0.7,1)

	#legend("bottomright", col=c(rgb(1,0,0.2), rgb(0,1,0.2)), lty=c(1,1), legend=c(paste("Worst Alignment: ", prcMin, sep=""),paste("100% Identity")))
	dev.off()

	png(paste(outf, "/", onm, "_chart.png",sep=""), height=500, width=800)
	layout(matrix(1:2,ncol=2), width = c(4,1),height = c(1,1))
	par(mar=c(5.1, 4.1,4.1, 1))
	plot(0,0,col=rgb(0,0,0,0), xlim=c(0,mxx), ylim=c(0,mxy), xlab="Length of Transcript (bp)", ylab="Genomic Read Depth (DNASeq)", main=paste(onm, " pileup-map", sep=""))
	grid()
	for(j in 1:ln)
	{
		prc <- (slines[[j]]$Perc[1]) - prcMin

		cl <- rgb(1-(prc/prcMx), prc/prcMx, 0.2,0.4)

		ln2 <- length(slines[[j]]$TsStart)

		xs <- seq(slines[[j]]$TsStart[1], (ln2*10) + slines[[j]]$TsStart[1] + 10, 10)

		xs <- xs[1:length(slines[[j]]$Depth)]

		points(xs, slines[[j]]$Depth, type="l", col=cl, lwd=3)
	}
	legend_image <- as.raster(matrix(colfunc(20), ncol=1))
	par(mar=c(3, 1,3, 2.1), cex=0.8)
	plot(c(0,2),c(-1,2),type = 'n', axes = F,xlab = '', ylab = '')
	text(x=1.1, y = seq(0.02,0.98,l=5), labels = seq(prcMin,100,l=5))
	text(0.8,1.2, labels="Alignment Identites")
	rasterImage(legend_image, 0, 0, 0.7,1)

	#legend("bottomright", col=c(rgb(1,0,0.2), rgb(0,1,0.2)), lty=c(1,1), legend=c(paste("Worst Alignment: ", prcMin, sep=""),paste("100% Identity")))
	dev.off()
}
