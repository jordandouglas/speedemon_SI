if (!require(rjson , quietly = T)) install.packages("rjson")
library(rjson)


BURNIN = 0.5
NSIMS = 100

getTrees = function(fileName){

	file.in = readLines(fileName, warn=F)
	trees = file.in[grep("tree STATE_", file.in)]
	trees = gsub(".+[=] ", "", trees)
	
	# Translate
	trans = file.in[(grep("Translate", file.in)+1):(grep("^;$", file.in)-1)[1]]
	trans = gsub("\t", "", trans)
	trans = gsub("^ +", "", trans)
	trans = gsub(",", "", trans)
	indexes = sapply(strsplit(trans, " "), function(ele) ele[1])
	labels  = sapply(strsplit(trans, " "), function(ele) ele[2])
	
	
	for (i in 1:length(indexes)){
	
		trees = gsub(paste0("[(]", indexes[i], "[:]"), paste0("(", labels[i], ":"), trees)
		trees = gsub(paste0(",", indexes[i], "[:]"), paste0(",", labels[i], ":"), trees)
		trees = gsub(paste0("[(]", indexes[i], "[[]"), paste0("(", labels[i], "["), trees)
		trees = gsub(paste0(",", indexes[i], "[[]"), paste0(",", labels[i], "["), trees)
	
	}
	
	trees

}



# Read parameters
truth.df = read.table("truth/starbeast3.log", header=T, sep = "\t")

# Read species tree
species.trees = getTrees("truth/species.trees")



# Read gene trees
files = list.files("truth/", "[0-9]+.trees")
gene.trees.list = list()
gNums = character(0)
for (f in files){

	gnum = paste0("gene", gsub("[.]trees", "", f))
	cat(paste(gnum, "\n"))
	gene.trees = getTrees(paste0("truth/", f))
	gene.trees.list[[gnum]] = gene.trees
	gNums = c(gNums, gnum)

}
names(gene.trees.list) = gNums


# Postprocessing burnin
burnin.start = floor(BURNIN*nrow(truth.df))
if (burnin.start <= 0) burnin.start = 1
include = seq(from = burnin.start, to = nrow(truth.df), length = NSIMS)
include = floor(include)



# Prepare folders
for (simnum in 1:NSIMS){

	rownum = include[simnum]
	
	
	#tmp
	#simnum = simnum - 1

	f = paste0("templates/rep", simnum)
	cat(paste(f, "\n"))
	dir.create(f, showWarnings=F) 
	
	
	
	# Create json
	JSON = list()
	
	
	# Prior variables
	sub.df = truth.df[rownum,]
	for(x in colnames(sub.df)){
		val = sub.df[,x]
		JSON[[x]] = val
	}	
	
	
	# Species trees
	JSON[["speciesTree"]] = species.trees[rownum]
	write(JSON[["speciesTree"]], paste0(f, "/trueSpecies.newick"))
	
	# Gene trees
	for (gnum in names(gene.trees.list)){
		JSON[[gnum]] = gene.trees.list[[gnum]][rownum]
	}

	JSON_str = as.character(rjson::toJSON(JSON, indent=1))
	write(JSON_str, paste0(f, "/var.json"))

}









