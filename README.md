# 16S-rDNA-decon-pipeline  is under construction

# Decontamination of the Microbiome Sequence data
Decontamination is a process of removing contaminant sequences (OTUs) from the biological / target samples sequences data. Potential sources of contaminants are the DNA isolation and purification reagents, sample storage media, sampling tools, laboratory environments and researchers. This module points some of the aspects to implemented in the wetlab as well as in the dtrylab for the efficient implementation of the deconatmanation process. Lastly, provides a script which can detect and remove contaminant sequence from the target microbome sequence data.

# In the Wetlab
At least three replicate of a blank (or sampling media) spiked with known pure bacteria isolate (prefereably not expected in your study profile) should be prepared. the spiking concetration should be comparable to the concentration in the target biological sample. If there is high disperity of the DNA concentration levels betweem biological samples, then, spiked controls can as wellbe prepared at both the higher levels and lower levels. The objective is to introduce a relatively similar competition of the DNA from different OTUs during the amplification process. Run the DNA isolation, library preparation and sequencing in exactly the same ways as in the tareget biological samples.
# Bionformatics processing
1. Run QC and OTU picking and the taxonomic annotation of the spiked controls and biological samples separatedly
2. Check reproducibility of the controls replicates by comparing percentage of reads in each replicate
3. If sequence reads are comparable between replicates, then calculate average sequence reads of each OTU detected
4. Remove the spiked OTUs (the most abundant) retain only the contaminants / background sequences
5. Search for contaminant sequences in the target sample by aligning contaminant sequence against the pre-aligned biological sample sequences as shown below

"align_seq.py -i $inDir/conta.fa -o $outDir/decont100 -t $inDir/otus_prealigned.fa -m PyNAST -a uclust -e 250 -p 100 "

Whereby
- conta.fa: Is a fasta file with sequences from the background of the spiked control after removing the spiked bacteria sequence
- decon100: Is a folder to which the output will be directed
- otus_prealigned.fa: I a fasta file of the prealigned biological sample sequences
- -e = 250: Align sequences at their entire length. i.e. 250bp
- -p = 100: Percent sequence similarity between contaminant and the biological sample sequences
- -m = PyNAST: Method for aligning sequences
- -a =uclust: Method of performing pairwise sequence alignment in PyNAST
Detection of contaminants in the biological sample will be revealed by presence of OTUs from spiked control mapping to their respective OTUs in the bioloigica sample.
Then, the average reads of the contaminant OTUs sequences will be substracted from the mapped biological sample OTU sequences. i.e subtraction of contaminant sequence reads/ OTUS will be done from the biological sample otu_table.
# Output files
* conta_aligned.fa: Is a fasta file with sequences which aligned to the biological sample sequences
* conta_failures.fa: Is a fasta file with sequences which did not align to biological sample sequences
* conta_log.txt: This is a summary file showing contaminant OTU which aligned to biological sample sequences. Summary file shows contaminant OTUs which mapped to biological sample OTUs.
# Removing contaminants from the biological sample
Average reads of contaminant OTUs will be subtracted from their respective mapped OTUs in the biological sample otu-table.txt (the nextflow output in the folder otu-picking/). If the number of reads in the contaminant OTU is higher than in their respective OTU in the biological sample, then the entire OTU will be removed, otherwise, only the equilavent reads will subtracted.

