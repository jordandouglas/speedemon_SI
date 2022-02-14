#!/bin/bash



# Prepare templates to do WCSS


# Sample from prior
mkdir -p truth
cd truth
/mnt/e/STOREDFILES/BEAST2/linux/beast/bin/beast -overwrite ../truth.xml
cd ../



# Populate templates
mkdir -p templates
Rscript ../scripts/populate.R



# Simulate sequences
perl wcss.pl


# Tidy up
rm simsnap.fas
rm simsnap.cfg