# RNAseq Transcript -> Genome Assembly Pileup Context Graphs

A basic system to integrate the separate transcriptomics with a partially assembled genome.

When working with organisms with highly allelically divergent genomes (>5% absolute), it can be difficult to distinguish isoforms from paralogs from alleles in the transcriptome assembly. It is also typically the case that the assembled verison of that organism's genome will be a mish-mash of collapsed and uncollapsed alleles, and in the case of assemblies that collapse aggressively, it may also have substantial paralog collapse misasseblies as a tradeoff.

This short pipeline allows the user to assess the genome assembly circumstance behand the transcript(s) they are interested in.

## Running the preparation steps

```samtools mpileup <readmaps.bam> | perl mpileuptowig.pl > customwig.mat```
