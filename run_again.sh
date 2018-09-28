#!/bin/bash

#Usage: ./run_again.sh <customwig.mat> <my_genome.fasta> <transcripts.fasta> <output_directory>

if [ -z "$4" ]
then
echo "You are missing argument 4: Output Directory!\n"
fi

if [ -z "$3" ]
then
echo "You are missing argument 3: Transcript fasta file\n"
fi

if [ -z "$2" ]
then
echo "You are missing argument 2: Genome fasta file\n"
fi

if [ -z "$1" ]
then
echo "You are missing argument 1: Custom Wig file\n"
fi

if [ $# -eq 4 ]
then

mkdir $4

makeblastdb -in ${2} -dbtype nucl -parse_seqids

blastn -query ${3} -db ${2} -evalue 5e-05 -outfmt 6 > "${4}/${2}_blast.outfmt6"

rm -f ${2}.*

perl RNA_pileup_insight.pl "${4}/${2}_blast.outfmt6" ${1} $4

awk '{if($2) print $2}' ${1} > temp_wig.mat

Rscript Draw_kdens.R temp_wig.mat $4

rm -f temp_wig.mat

rm -f *_points.txt

fi
