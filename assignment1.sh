#!/bin/bash
		
mkdir ${HOME}/fastqcRNAseq/
#Directory made that will contain output of fastqc 
cd /localdisk/data/BPSM/Assignment1/fastq/
fastqc --outdir=${HOME}/fastqcRNAseq/ 216_L8_1.fq.gz  216_L8_2.fq.gz  218_L8_1.fq.gz  218_L8_2.fq.gz  219_L8_1.fq.gz  219_L8_2.fq.gz  220_L8_1.fq.gz  220_L8_2.fq.gz  221_L8_1.fq.gz 221_L8_2.fq.gz  222_L8_1.fq.gz  222_L8_2.fq.gz
echo Quality check performed on paired-end raw sequence using fastqc 
cp /localdisk/data/BPSM/Assignment1/Tbb_genome/Tb927_genome.fasta.gz ~/assignment1/Tb927_genome.fasta.gz
gunzip ~/assignment1/Tb927_genome.fasta.gz
#Index of Tbb genome created in preparation of running bowtie2 
bowtie2-build ~/assignment1/Tb927_genome.fasta ~/assignment1/Tbb_index
echo Tbb index created  
bowtie2 -x ~/assignment1/Tbb_index -S ~/assignment1/readpairsoutput.sam -U 216_L8_1.fq.gz,216_L8_2.fq.gz,218_L8_1.fq.gz,218_L8_2.fq.gz,219_L8_1.fq.gz,219_L8_2.fq.gz,220_L8_1.fq.gz,220_L8_2.fq.gz,221_L8_1.fq.gz,221_L8_2.fq.gz,222_L8_1.fq.gz,222_L8_2.fq.gz 
echo Read pairs aligned to Trypanosoma brucei brucei genome using bowtie2 programme
samtools view -S -b ~/assignment1/readpairsoutput.sam > ~/assignment1/readpairsoutput.bam
#Output sam file from bowtie2 converted to bam 
bedtools intersect -bed -a ~/assignment1/readpairsoutput.bam -b /localdisk/data/BPSM/Assignment1/Tbbgenes.bed | head -10
echo The number of reads that align to the regions of the genome that code for genes completed using bedtools 
