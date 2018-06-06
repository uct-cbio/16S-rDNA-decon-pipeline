#!/bin/bash

##Transposing otu-table.txt for easy subtraction of contaminant reads

maxf="$(awk '{if (mf<NF); mf=NF}; END{print mf}' otu-table.txt)" 
rowcount=maxf
for (( i=1; i<=rowcount; i++ )); do
    awk -v i="$i" -F " " '{printf("%s\t ", $i)}' otu-table.txt
    echo
done >> trans-otu-table.txt

##Removing contaminant reads

awk 'NR==1; BEGIN{FS=OFS="\t"}{;$6=$6-400; $2=$2-10}1' trans-otus-table.txt | sed '2d'|awk '$2<0 {$2=0}; $6<0 {$6=0} 1' OFS='\t' > decont-table.txt

##NOTE: $2 and $6 are the OTUs columns in the biological samples which mapped to the contaminant reads. 400 and 10 are their respective average reads from the background of the spiked controls 


##.Transposing otu-table to qiime compatible format ..................................

maxf="$(awk '{if (mf<NF); mf=NF}; END{print mf}' decont-table.txt)"
rowcount=maxf
for (( i=1; i<=rowcount; i++ )); do
    awk -v i="$i" -F " " '{printf("%s\t ", $i)}' decont-table.txt
    echo
done >> final-otu-table.txt
