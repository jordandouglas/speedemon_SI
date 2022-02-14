#!/bin/bash



# Run cluster set analyser on the SNAPPER tree outputs
cd templates
for r in rep*/;
do

	echo $r

	cd $r
	 /mnt/e/STOREDFILES/BEAST2/linux/beast/bin/applauncher ClusterTreeSetAnalyser -trees mcmc.trees -out posterior.clusters -burnin 10 -epsilon 1e-4
	 /mnt/e/STOREDFILES/BEAST2/linux/beast/bin/applauncher ClusterTreeSetAnalyser -trees trueSpecies.newick -out true.clusters -burnin 10 -epsilon 1e-4
	 
	 

	 
	 
	cd ../

done

Rscript ../scripts/clusters.R
Rscript ../scripts/plots.R FALSE
