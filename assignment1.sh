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
bowtie2 -x ~/assignment1/Tbb_index -S ~/assignment1/sle216_readpairs.sam -1 216_L8_1.fq.gz -2 216_L8_2.fq.gz
bowtie2 -x ~/assignment1/Tbb_index -S ~/assignment1/sle218_readpairs.sam -1 218_L8_1.fq.gz -2 218_L8_2.fq.gz
bowtie2 -x ~/assignment1/Tbb_index -S ~/assignment1/sle219_readpairs.sam -1 219_L8_1.fq.gz -2 219_L8_2.fq.gz 
echo Read pairs for slender form aligned to Trypanosoma brucei brucei genome using bowtie2
bowtie2 -x ~/assignment1/Tbb_index -S ~/assignment1/stu220_readpairs.sam -1 220_L8_1.fq.gz -2 220_L8_2.fq.gz
bowtie2 -x ~/assignment1/Tbb_index -S ~/assignment1/stu220_readpairs.sam -1 221_L8_1.fq.gz -2 221_L8_2.fq.gz
bowtie2 -x ~/assignment1/Tbb_index -S ~/assignment1/stu220_readpairs.sam -1 222_L8_1.fq.gz -2 222_L8_2.fq.gz
echo Read pairs for stumpy form aligned to Trypanosoma brucei brucei genome using bowtie2
#Convert output sam files from bowtie2 to bam format using samtools
samtools view -S -b ~/assignment1/sle216_readpairs.sam > ~/assignment1/sle216_readpairs.bam
samtools view -S -b ~/assignment1/sle218_readpairs.sam > ~/assignment1/sle218_readpairs.bam
samtools view -S -b ~/assignment1/sle219_readpairs.sam > ~/assignment1/sle219_readpairs.bam
samtools view -S -b ~/assignment1/stu220_readpairs.sam > ~/assignment1/stu220_readpairs.bam
samtools view -S -b ~/assignment1/stu221_readpairs.sam > ~/assignment1/stu221_readpairs.bam
samtools view -S -b ~/assignment1/stu222_readpairs.sam > ~/assignment1/stu222_readpairs.bam
echo Conversion from sam to bam complete 
#Sequences sorted using samtools 
samtools sort ~/assignment1/sle_readpairs.bam -o ~/assignment1/sle_sort.readpairs.bam
samtools sort ~/assignment1/stu_readpairs.bam -o ~/assignment1/stu_sort.readpairs.bam 
