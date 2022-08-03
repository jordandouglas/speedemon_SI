# SPEEDEMON Supporting Information

This repository provides supplementary data for the manuscript "*Quantitatively defining species boundaries with more efficiency and  more biological realism*". This manuscript describes species delimitation methods, based on the tree collapse prior distribution described by [Jones et al](https://link.springer.com/article/10.1007/s00285-016-1034-0). The BEAST 2 package source code for this project is available in a separate repository [here](https://github.com/rbouckaert/speedemon). Instructions can be found there for installing BEAST 2 and the SPEEDEMON package, allowing the XML files in this repository to be run from the command line.



## 1. Well-calibrated simulation studies

This section describes how to simulate parameters from the prior distribution, and then estimate the parameters using data simulated under the true parameters.  Both subsections below assume that BEAST 2 is installed at ``~/beast/bin/``. If this assumption is incorrect, then some of the scripts may need to be modified.

### 1.1 StarBeast3
To perform well-calibrated simulation study on the Yule-skyline collapse model under StarBeast3:

```
# Sample from the prior distribution over 100 replicates 
cd wcss/starbeast3
bash prepare.sh
```
This code will run ``truth.xml`` using BEAST 2, and export the resulting parameters into a file called ``var.json`` (one file per replicate). ``var.json`` contains variables which can be inserted into ``mcmc.xml`` using BEAST 2:

```
cd templates
cd rep1
~/beast/bin/beast -df var.json ../../mcmc.xml
```

After BEAST 2 has been run on all 100 replicates, the well-calibrated simulation study can be run using:

``
bash wcss.sh
``


### 1.2 SNAPPER

Simulating data requires 1. Perl, 2. SimSnap, which can be downloaded [here](https://github.com/BEAST2-Dev/SNAPP/tree/master/SimSnap)  and is assumed to be saved in a directory ~/SNAPP/SimSnap/simsnap``.To simulate data:
```
# Sample from the prior distribution over 100 replicates 
cd wcss/snapper
bash prepare.sh
```

After the parameters and SNP data have been simulated, 100 directories will be created in ``templates/``,  and each directory contains  ``mcmc.xml`` (containing the data) and ``var.json`` (containing the true parameters used to simulate the data). To infer parameters from the data, run BEAST 2 on ``mcmc.xml``:


```
cd templates
cd rep1
~/beast/bin/beast mcmc.xml
```

After BEAST 2 has been run on all 100 replicates, the well-calibrated simulation study can be run using:

``
bash wcss.sh
``

## 2. Benchmarking
We benchmarked the performances of StarBeast3 and STACEY using two datasets. Each XML file was run for 20 replicates of MCMC.


### 2.1 Lizard
We used the multilocus lizard genomic data by [Ashman et al](https://doi.org/10.1111/evo.13541).

[stacey.xml](https://github.com/jordandouglas/speedemon_SI/blob/main/efficiency/lizard/stacey.xml): the XML file used to benchmark STACEY, under the birth-collapse model
[starbeast3.xml](https://github.com/jordandouglas/speedemon_SI/blob/main/efficiency/lizard/starbeast3.xml): the XML file used to benchmark StarBeast3, under the birth-collapse model

### 2.1 Simulated
We used multilocus simulated genomic data by [Douglas et al](https://doi.org/10.1101/2021.10.06.463424).

[stacey.xml](https://github.com/jordandouglas/speedemon_SI/blob/main/efficiency/simulated/stacey.xml): the XML file used to benchmark STACEY, under the birth-collapse model
[starbeast3.xml](https://github.com/jordandouglas/speedemon_SI/blob/main/efficiency/simulated/starbeast3.xml): the XML file used to benchmark StarBeast3, under the birth-collapse model

## 3. Applications

### 3.1 Geckos
We applied SNAPPER to gecko SNP data by [Leache et al](https://doi.org/10.1093/sysbio/syu018).

- [snapper.xml](https://github.com/jordandouglas/speedemon_SI/blob/main/applications/leache/snapper.xml): the XML file used to analyse the  dataset with the YSC model
- [bfdH1/bfd.xml](https://github.com/jordandouglas/speedemon_SI/blob/main/applications/leache/bfdH1/bfd.xml): hypothesis H1, explored by Bayes factor delimitation 
- [bfdH2/bfd.xml](https://github.com/jordandouglas/speedemon_SI/blob/main/applications/leache/bfdH2/bfd.xml): hypothesis H2, explored by Bayes factor delimitation 
- [bfdH3/bfd.xml](https://github.com/jordandouglas/speedemon_SI/blob/main/applications/leache/bfdH3/bfd.xml): hypothesis H3, explored by Bayes factor delimitation 
- [results](https://github.com/jordandouglas/speedemon_SI/blob/main/applications/leache/results): summary tree files from snapper.xml

### 3.2 Primates
We applied StarBeast3 to primate genomic data by [Pozzi et al](https://doi.org/10.1186/1471-2148-14-72). 
- [starbeast3.xml](https://github.com/jordandouglas/speedemon_SI/blob/main/applications/pozzi/starbeast3.xml): the XML file used to analyse the  dataset with the YSC model
- [results](https://github.com/jordandouglas/speedemon_SI/blob/main/applications/pozzi/results): summary tree files from starbeast3.xml




