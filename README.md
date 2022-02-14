# SPEEDEMON Supporting Information

This repository provides supplementary data for the manuscript "*Quantitatively defining species boundaries with more efficiency and  more biological realism*". This manuscript describes species delimitation methods, based on the tree collapse prior distribution described by [Jones et al](https://link.springer.com/article/10.1007/s00285-016-1034-0). The BEAST 2 package source code for this project is available in a separate repository [here](https://github.com/rbouckaert/speedemon). Instructions can be found there for installing BEAST 2 and the SPEEDEMON package, allowing the XML files in this repository to be run from the command line.



## 1. Well-calibrated simulation studies

## 2. Benchmarking

## 3. Applications

### 3.1 Geckos
We applied SNAPPER to gecko SNP data by [Leache et al](https://doi.org/10.1093/sysbio/syu018).

- snapper.xml: the XML file used to analyse the  dataset with the YSC model
- bfdA/bfd.xml: hypothesis A, explored by Bayes factor delimitation 
- bfdF/bfd.xml: hypothesis F, explored by Bayes factor delimitation 
- bfdT/bfd.xml: hypothesis T, explored by Bayes factor delimitation 


### 3.2 Primates
We applied StarBeast3 to primate genomic data by [Pozzi et al](https://doi.org/10.1186/1471-2148-14-72). 
- starbeast3.xml: the XML file used to analyse the  dataset with the YSC model