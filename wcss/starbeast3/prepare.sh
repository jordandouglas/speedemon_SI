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



# After this has been done, run MCMC in each templates/rep*/ subdirectory
# This can be done using 
# 		~/beast/bin/beast -df var.json ../../mcmc.xml 



# Then, when all the chains have run, use 
#		bash wcss.sh
# To perform the test
