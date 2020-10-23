#!/bin/bash

#Aborts script if error occurs
set -e
#Variables that contain path of directories
ASSIGNMENT_DIR="/localdisk/data/BPSM/Assignment1"
SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
FASTQC_OUT=${SCRIPT_LOCATION}/fastqcRNAseq/

#Directory created that will contain output of fastqc
mkdir -p ${FASTQC_OUT} 
cd ${ASSIGNMENT_DIR}/fastq/
fastqc --outdir=${FASTQC_OUT} 216_L8_1.fq.gz  216_L8_2.fq.gz  218_L8_1.fq.gz  218_L8_2.fq.gz  219_L8_1.fq.gz  219_L8_2.fq.gz  220_L8_1.fq.gz  220_L8_2.fq.gz  221_L8_1.fq.gz 221_L8_2.fq.gz  222_L8_1.fq.gz  222_L8_2.fq.gz 
echo "Quality check performed on paired-end raw sequence using fastqc. View HTML reports in a browser to analyse output."

cd ${SCRIPT_LOCATION}
#Tb927 genome copied to script location and unzipped
cp ${ASSIGNMENT_DIR}/Tbb_genome/Tb927_genome.fasta.gz ${SCRIPT_LOCATION}/Tb927_genome.fasta.gz
gunzip -f ${SCRIPT_LOCATION}/Tb927_genome.fasta.gz
echo "Tb927_genome unzipped"

#Index of Tb927 genome created in preparation of running bowtie2 
bowtie2-build ${SCRIPT_LOCATION}/Tb927_genome.fasta ${SCRIPT_LOCATION}/Tbb_index
echo "Tbb_index successfully built"

#Loop that runs bowtie2 alignment of read pairs against Tbb, converts sam output to bam format, then sorts and indexes bam files.  
for fqfile in $(ls ${ASSIGNMENT_DIR}/fastq/*1.fq.gz)
do
	fqfileno=$(basename ${fqfile} | cut -d "_" -f 1) 
	bowtie2 -x ${SCRIPT_LOCATION}/Tbb_index -1 ${ASSIGNMENT_DIR}/fastq/${fqfileno}_L8_1.fq.gz -2 ${ASSIGNMENT_DIR}/fastq/${fqfileno}_L8_2.fq.gz -S ${SCRIPT_LOCATION}/${fqfileno}.sam
	samtools view -S -b ${SCRIPT_LOCATION}/${fqfileno}.sam > ${SCRIPT_LOCATION}/${fqfileno}readpairs.bam
	samtools sort ${SCRIPT_LOCATION}/${fqfileno}.sam -o  ${SCRIPT_LOCATION}/${fqfileno}sorted_readpairs.bam
	samtools index -b ${SCRIPT_LOCATION}/${fqfileno}sorted_readpairs.bam 
done  
echo "bowtie2 alignment and samtools commands successfully complete"

#Bedtools run for slender forms
bedtools multicov -bams ${SCRIPT_LOCATION}/216sorted_readpairs.bam ${SCRIPT_LOCATION}/218sorted_readpairs.bam ${SCRIPT_LOCATION}/219sorted_readpairs.bam -bed ${ASSIGNMENT_DIR}/Tbbgenes.bed > ${SCRIPT_LOCATION}/slendercounts
echo "Count data for slender forms complete using bedtools"
#Bedtool run for stumpy forms 
bedtools multicov -bams ${SCRIPT_LOCATION}/220sorted_readpairs.bam ${SCRIPT_LOCATION}/221sorted_readpairs.bam ${SCRIPT_LOCATION}/222sorted_readpairs.bam -bed ${ASSIGNMENT_DIR}/Tbbgenes.bed > ${SCRIPT_LOCATION}/stumpycounts
echo "Count data for stumpy forms complete using bedtools"

#Generation of plain text file summarising slender and stumpy mean for each gene. 
printf "%s\t%s\t%s\n" "Gene Name" "Slender Mean" "Stumpy Mean" >> ${SCRIPT_LOCATION}/summarycounts.txt 
paste <(cut -f 4 ${SCRIPT_LOCATION}/slendercounts) <(cut -f 7-9 ${SCRIPT_LOCATION}/slendercounts) <(cut -f 7-9 ${SCRIPT_LOCATION}/stumpycounts) | while read -r gene c1 c2 c3 c4 c5 c6
do
	avg1=$(((c1 + c2 + c3) / 3))
	avg2=$(((c4 + c5 + c6) / 3))
	printf "%s\t%d\t%d\n" "$gene" $avg1 $avg2 >> ${SCRIPT_LOCATION}/summarycounts.txt  
done
echo "Summary text file generated containing mean of counts per gene for slender an stumpy forms"
echo "Script complete"
