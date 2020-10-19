#!/bin/bash
		
mkdir ${HOME}/fastqcRNAseq/
cd /localdisk/data/BPSM/Assignment1/fastq/
fastqc --outdir=${HOME}/fastqcRNAseq/ 216_L8_1.fq.gz  216_L8_2.fq.gz  218_L8_1.fq.gz  218_L8_2.fq.gz  219_L8_1.fq.gz  219_L8_2.fq.gz  220_L8_1.fq.gz  220_L8_2.fq.gz  221_L8_1.fq.gz 221_L8_2.fq.gz  222_L8_1.fq.gz  222_L8_2.fq.gz
cp /localdisk/data/BPSM/Assignment1/Tbb_genome/Tb927_genome.fasta.gz ~/assignment1/Tb927_genome.fasta.gz
gunzip ~/assignment1/Tb927_genome.fasta.gz
bowtie2-build ~/assignment1/Tb927_genome.fasta ~/assignment1/Tbb_index  
bowtie2 -x ~/assignment1/Tbb_index -S ~/assignment1/readpairsoutput.sam -U 216_L8_1.fq.gz,216_L8_2.fq.gz,218_L8_1.fq.gz,218_L8_2.fq.gz,219_L8_1.fq.gz,219_L8_2.fq.gz,220_L8_1.fq.gz,220_L8_2.fq.gz,221_L8_1.fq.gz,221_L8_2.fq.gz,222_L8_1.fq.gz,222_L8_2.fq.gz 
samtools view -S -b ~/assignment1/readpairsoutput.sam > ~/assignment1/readpairsoutput.bam 
bedtools intersect -a readpairs.bam -b /localdisk/data/BPSM/Assignment1/Tbbgenes.bed
