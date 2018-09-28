#!/bin/bash

#Usage: ./run_all.sh <sorted.bam> <my_genome.fasta> <transcripts.fasta> <output_directory>

if [ !$4 ]
then
echo "You are missing argument 4: Output Directory!\n"
fi

if [ !$3 ]
then
echo "You are missing argument 4: Transcript fasta file\n"
fi

if [ !$2 ]
then
echo "You are missing argument 2: Genome fasta file\n"
fi

if [ !$1 ]
then
echo "You are missing argument 1: Sorted Bam File\n"
fi

if [ $4 ]
then

samtools mpileup ${1} | perl mpileuptowig.pl > ${1}.mat

makeblastdb -in ${2} -dbtype nucl -parse_seqids

blastn -query ${3} -db ${2} -evalue 5e-05 -outfmt 6 > ${2}.outfmt6

perl ts_pileup_insight.pl blast.outfmt6 ${1}.mat

rm -f *_points.txt

fi
