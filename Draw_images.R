args = commandArgs(trailingOnly=TRUE)

for(i in args)
{
	df <- read.table(i, sep="\t", header=TRUE)

	nm <- strsplit(i, "_points")

	onm <- nm[[1]][1]

	slines <- split(df, df$HitID)

	ln <- length(slines)

	mxx <- 0
	mxy <- max(df$Depth)

	for(j in 1:ln)
	{
		if(slines[[j]]$Reverse[1] == 1)
		{
			slines[[j]]$Depth <- rev(slines[[j]]$Depth)
		}

		ty <- (length(slines[[j]]$Depth) * 10) + slines[[j]]$TsStart[1]

		mxx <- pmax(ty, mxx)
	}
	pdf(paste(onm, "_chart.pdf",sep=""), height=5, width=8)
	plot(0,0,col=rgb(0,0,0,0), xlim=c(0,mxx), ylim=c(0,mxy), xlab="Length of Transcript (bp)", ylab="Genomic Read Depth (DNASeq)")

	for(j in 1:ln)
	{
		prc <- slines[[j]]$Perc[1]

		cl <- rgb(1-(prc/100), prc/100, 0.2,1)

		ln2 <- length(slines[[j]]$TsStart)

		xs <- seq(slines[[j]]$TsStart[1], (ln2*10) + slines[[j]]$TsStart[1] + 10, 10)

		xs <- xs[1:length(slines[[j]]$Depth)]

		points(xs, slines[[j]]$Depth, type="l", col=cl)
	}
	dev.off()
}
