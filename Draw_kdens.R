args = commandArgs(trailingOnly=TRUE)

inf <- args[1]

outf <- args[2]

wg <- read.table(inf, header=FALSE)

wg2 <- wg$V1[wg$V1 > quantile(wg$V1, 0.02) & wg$V1 < quantile(wg$V1, 0.98)]

pdf(paste(outf, "/reference_density.pdf", sep=""), height=5, width=5)
plot(density(wg2), xlab="Read Coverage Across Scaffolds", ylab="Kernel Density", main="Full Genome Pileup Depth Distribution", lwd=2)
grid()
dev.off()

png(paste(outf, "/reference_density.png", sep=""), height=500, width=500)
plot(density(wg2), xlab="Read Coverage Across Scaffolds", ylab="Kernel Density", main="Full Genome Pileup Depth Distribution", lwd=2)
grid()
dev.off()
