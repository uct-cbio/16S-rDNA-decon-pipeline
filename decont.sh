#!/bin/bash

##Transposing otu-table.txt for easy subtraction of contaminant reads

maxf="$(awk '{if (mf<NF); mf=NF}; END{print mf}' otu-table.txt)" 
rowcount=maxf
for (( i=1; i<=rowcount; i++ )); do
    awk -v i="$i" -F " " '{printf("%s\t ", $i)}' otu-table.txt
    echo
done >> trans-otu-table.txt

## Removing contaminant reads

awk 'NR==1; BEGIN{FS=OFS="\t"}{;$6=$6-4; $23=$23-9; $87=$87-1}1' trans-otus-table.txt | sed '2d'|awk '$6<0 {$6=0}; $23<0 {$23=0}; $87<0 {$87=0}1' OFS='\t' > decont-table.txt

## NOTE: $6 and $23 and $87 are the columns of the OTUS in the target biological sample otu-table which mapped to the contaminant OTUs, while 4, 9 and 1 are their respective average reads in the background of the spiked controls 


## Transposing otu-table to qiime compatible format

maxf="$(awk '{if (mf<NF); mf=NF}; END{print mf}' decont-table.txt)"
rowcount=maxf
for (( i=1; i<=rowcount; i++ )); do
    awk -v i="$i" -F " " '{printf("%s\t ", $i)}' decont-table.txt
    echo
done >> final-otu-table.txt ## This table can now be used in the downstream processing such as the BIOM file generation
