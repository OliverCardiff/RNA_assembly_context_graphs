# RNAseq Transcript -> Genome Assembly Pileup Context Graphs

A basic system to integrate the separate transcriptomics with a partially assembled genome.

When working with organisms with highly allelically divergent genomes (>5% absolute), it can be difficult to distinguish isoforms from paralogs from alleles in the transcriptome assembly. It is also typically the case that the assembled verison of that organism's genome will be a mish-mash of collapsed and uncollapsed alleles, and in the case of assemblies that collapse aggressively, it may also have substantial paralog collapse misasseblies as a tradeoff.

This short pipeline allows the user to assess the genome assembly circumstance behand the transcript(s) they are interested in.

## Prerequisites 

#### Software

1. [BLAST+](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download)
2. [Samtools/1.5 or later](http://www.htslib.org/download/)
3. [R 3.x+](https://www.r-project.org/)
4. A short read aligner

#### Data

1. A fasta file containing 'transcripts of interest'
2. A fasta file containing a genome assembly (of dubious quality most likely)
3. The short-read library used to assemble the genome

## Running the preparation steps

### 1. Align the short-read library to the genome

This can be done with your chosen aligner but highly sensitive presets are recommended

For example with [bbmap](https://github.com/BioInfoTools/BBMap):

```bbmap.sh in1=reads1.fq in2=reads2.fq out=mapped_Reads.sam ref=genome.fasta```

### 2. Sort, Index & Convert bam to custom Wig file

Convert to bam:

```samtools view mapped_reads.sam > mapped_reads.bam```

Sort:

```samtools sort -o msort.bam mapped_reads.bam```

Index:

```samtools index msort.bam```

### 3. Create Custom Wig file

Run the included script [mpileuptowig.pl](mpileuptowig.pl):

```samtools mpileup msort.bam | perl mpileuptowig.pl > customwig.mat```
