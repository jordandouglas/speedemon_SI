#!/bin/bash


# This script should be run after mcmc has been run in each directory in templates/

cd templates
for r in rep*/;
do

	echo $r

	cd $r
	
	# Cluster set analyser for the posterior distribution
	~/beast/bin/applauncher ClusterTreeSetAnalyser -trees species.trees -out posterior.clusters -burnin 10 -epsilon 1e-4
	 

	# Cluster set analyser for the true tree
	~/beast/bin/applauncherapplauncher ClusterTreeSetAnalyser -trees trueSpecies.newick -out true.clusters -burnin 10 -epsilon 1e-4
	 

	 
	cd ../

done

cd ../


# WCSS
Rscript ../scripts/clusters.R 
Rscript ../scripts/plots.R TRUE
