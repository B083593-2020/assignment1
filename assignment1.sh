#!/bin/bash
	
mkdir -p ${HOME}/fastqcRNAseq/
#Directory made that will contain output of fastqc 
cd /localdisk/data/BPSM/Assignment1/fastq/
#fastqc --outdir=${HOME}/fastqcRNAseq/ 216_L8_1.fq.gz  216_L8_2.fq.gz  218_L8_1.fq.gz  218_L8_2.fq.gz  219_L8_1.fq.gz  219_L8_2.fq.gz  220_L8_1.fq.gz  220_L8_2.fq.gz  221_L8_1.fq.gz 221_L8_2.fq.gz  222_L8_1.fq.gz  222_L8_2.fq.gz
echo Quality check performed on paired-end raw sequence using fastqc
cp /localdisk/data/BPSM/Assignment1/Tbb_genome/Tb927_genome.fasta.gz ~/assignment1/Tb927_genome.fasta.gz
gunzip -f ~/assignment1/Tb927_genome.fasta.gz
#Index of Tb927 genome created in preparation of running bowtie2 
bowtie2-build ~/assignment1/Tb927_genome.fasta ~/assignment1/Tbb_index

#Loop that runs bowtie2 alignment of read pairs against Tbb, converts sam output to bam format then sorts and indexes bam files.  
for fqfile in $(ls /localdisk/data/BPSM/Assignment1/fastq/*1.fq.gz)
do
fqfileno=$(basename ${fqfile} | cut -d "_" -f 1) 
bowtie2 -x ~/assignment1/Tbb_index -1 /localdisk/data/BPSM/Assignment1/fastq/${fqfileno}_L8_1.fq.gz -2 /localdisk/data/BPSM/Assignment1/fastq/${fqfileno}_L8_2.fq.gz -S ~/assignment1/${fqfileno}.sam
samtools view -S -b ~/assignment1/${fqfileno}.sam > ~/assignment1/${fqfileno}readpairs.bam
samtools sort ~/assignment1/${fqfileno}.sam -o  ~/assignment1/${fqfileno}sorted_readpairs.bam
samtools index -b ~/assignment1/${fqfileno}sorted_readpairs.bam 
done  

#Bedtool run for slender forms
bedtools multicov -bams ~/assignment1/216sorted_readpairs.bam ~/assignment1/218sorted_readpairs.bam ~/assignment1/219sorted_readpairs.bam -bed /localdisk/data/BPSM/Assignment1/Tbbgenes.bed > ~/assignment1/slendercounts
#Bedtool run for stumpy forms 
bedtools multicov -bams ~/assignment1/220sorted_readpairs.bam ~/assignment1/221sorted_readpairs.bam ~/assignment1/222sorted_readpairs.bam -bed /localdisk/data/BPSM/Assignment1/Tbbgenes.bed > ~/assignment1/stumpycounts
