if (!require(HDInterval, quietly = T)) install.packages("HDInterval")
library(HDInterval)
if (!require(tikzDevice, quietly = T)) install.packages("tikzDevice")
library(tikzDevice)
if (!require(rjson , quietly = T)) install.packages("rjson")
library(rjson)


args <- commandArgs(trailingOnly = TRUE)

SB3 = TRUE

if (length(args) == 1) SB3 = args

BURNIN = 0.1
get.95 <- function(a.vector, discrete=F) {



 
  start = floor(BURNIN*length(a.vector))
  a.vector = a.vector[start:length(a.vector)]
  
  if (discrete){
  
	n = length(a.vector)
  
	# Find min(upper-lower) such that coverage >95%
	vals = sort(unique(a.vector))
	best.lower = -Inf
	best.upper = Inf
	best.freq = 0
	for(i in 1:length(vals)){
		freq = 0
		x = 0
		while (freq < 0.95*n){
			val = vals[i+x]
			f = sum(a.vector == val)
			freq = freq + f
			
			if (x+i >= length(vals)){
				break
			}
			
			x = x + 1
		
		}
		
		if (freq > 0.95*n) {
		
			lower = vals[i]
			upper = vals[i+x]
			if (upper - lower < best.upper - best.lower){
				best.upper = upper
				best.lower = lower
				best.freq = freq / n
			}
		
		}
		
		
		return(c(median(a.vector), best.lower, best.upper))
		
	}
	
  
  
  }else{
	res = hdi(a.vector, cresMass=.95)
	return(c(mean(a.vector), res[[1]], res[[2]]))
  }


}





if (SB3){

	cat("StarBeast3\n")

	params = c("TreeHeight.Species",  "bdcGrowthRateRate.t.Species",  "collapseWeight.t.Species", 
				"GeneHeight",  "popMean", "SpeciesTreeRelaxedClockSD.Species",
				"kappa.s.1", "freqParameter.t.1.1", "mutationRate.s.1")
				
				
	params.show = c(T, T, T,
					T, T, T,
					F, F, F)


}else{


	cat("SNAPPER\n")

	params = c("TreeHeight.stacey",  "bdcGrowthRateRate.Species",  "collapseWeight.Species")
				
	params.show = c(T, T, T) 

}


params.latex = lapply(params, function(p) p)
names(params.latex) = params
params.latex[["popMean"]] = "Mean effective population size"
params.latex[["popSize"]] = "Empirical mean effective population size"

params.latex[["kappa.s.1"]] = "HKY transition-transversion ratio"
params.latex[["freqParameter.t.1.1"]] = "Nucleotide frequency"
params.latex[["mutationRate.s.1"]] = "Gene tree mutation rate"
params.latex[["RateStatLogger.Species.mean"]] = "Mean branch rate $\\mathbb{E}({\\bf r})$"
params.latex[["SpeciesTreeRelaxedClockSD.Species"]] = "Branch rate standard deviation"
params.latex[["bdcGrowthRateRate.t.Species"]] = "Yule-skyline gamma rate"
params.latex[["bdcGrowthRateRate.Species"]] = "Yule-skyline gamma rate"
params.latex[["bdcGrowthRateShape.t.Species"]] = "Yule-skyline gamma shape"
params.latex[["collapseWeight.t.Species"]] = "Collapse weight $\\omega$"
params.latex[["collapseWeight.Species"]] = "Collapse weight $\\omega$"

params.latex[["TreeHeight.Species"]] = "Species tree height"
params.latex[["TreeHeight.stacey"]] = "Species tree height"
params.latex[["GeneHeight"]] = "Mean gene tree height"

params.latex[["snapperCoalescentRate.stacey"]] = "Coalescent rate (leaf 1)"
params.latex[["snapperCoalescentRate.stacey.1"]] = "Coalescent rate (leaf 1)"
params.latex[["snapperCoalescentRate.stacey.2"]] = "Coalescent rate (leaf 1)"
params.latex[["snapperCoalescentRate"]] = "Mean coalescent rate"



reps.to.keep = numeric(0)
#reps.to.keep = c(100,15,18,19,21,30,31,34,36,45,48,49,5,52,53,54,55,57,59,6,69,70,75,79,81,83)


wcss.df = data.frame(param = character(0), sample = numeric(0), mean = numeric(0), lower = numeric(0), upper = numeric(0), truth = numeric(0))


reps = list.files("templates/", "rep*")
for (r in reps){


	s = as.numeric(gsub("rep", "", r))
	sim = paste0("templates/", r, "/starbeast3.log")
	
	if (!file.exists(sim)){
		sim = paste0("templates/", r, "/mcmc.log")
	}
	
	
	if (length(reps.to.keep) > 0){
	
		if (!any(s == reps.to.keep)) next
	
	}


	if (!file.exists(sim)){
		cat(paste("Cannot find", sim, "\n"))
		next
	}

	#cat(paste(sim, "\n"))


	sim.df = read.table(sim, header=T, sep="\t")
	
	cat(paste("Replicate", s, "has", nrow(sim.df), "samples\n"))
	if (nrow(sim.df) < 10){
		cat(paste("\tSkipping\n"))
		next
	}


	# Truth
	truth.json <- fromJSON(file = paste0("templates/", r, "/var.json"))


	for (p in params){


		#print(p)
		


		if (p == "GeneHeight"){
		
			# mean branch rate
			height.cols = grep("TreeHeight.t.[0-9]", colnames(sim.df))
			vals = sapply(1:nrow(sim.df), function(x) mean(as.numeric(sim.df[x,height.cols])))
			
			
			# True value
			tvals = numeric(0)
			height.cols = grep("TreeHeight.t.[0-9]", names(truth.json))
			for (col in height.cols){
				tval = truth.json[[col]]
				tvals = c(tval, tvals)
			}
			t = mean(tvals)

			
		}else if (p == "popSize"){
		
			# mean pop size
			height.cols = grep("popSize.[0-9]", colnames(sim.df))
			vals = sapply(1:nrow(sim.df), function(x) mean(as.numeric(sim.df[x,height.cols])))
			
			
			# True value
			tvals = numeric(0)
			height.cols = grep("popSize.[0-9]", names(truth.json))
			for (col in height.cols){
				tval = truth.json[[col]]
				tvals = c(tval, tvals)
			}
			t = mean(tvals)
		
		
		
		}else if (p == "snapperCoalescentRate"){
		
			# mean pop size
			height.cols = grep("snapperCoalescentRate.stacey.[0-9]", colnames(sim.df))
			vals = sapply(1:nrow(sim.df), function(x) mean(as.numeric(sim.df[x,height.cols])))
			
			
			# True value
			tvals = numeric(0)
			height.cols = grep("snapperCoalescentRate.stacey.[0-9]", names(truth.json))
			for (col in height.cols){
				tval = truth.json[[col]]
				tvals = c(tval, tvals)
			}
			t = mean(tvals)
		
		
		
		}
		else {
		
		
			if (!any(colnames(sim.df) == p)){
				cat(paste("Skipping", p, "\n"))
				next
			}
		
			vals = sim.df[,p]
			
			# True value
			t = truth.json[[p]]
		
		}

		
		# Estimate
		hpd = get.95(vals)
		m = hpd[1]
		l = hpd[2]
		u = hpd[3]
		
		
		

		wcss.df2 = data.frame(param = p, sample = s, mean = m, lower = l, upper = u, truth = t)
		wcss.df = rbind(wcss.df, wcss.df2)



	}


	rm(sim.df)


}



# Make plots



ncol = 3
nrow = ceiling(sum(params.show) / ncol)

width = 3*ncol
height = 3*nrow

fileName = "wcss.tex"
		
options(tikzMetricPackages = c("\\usepackage[utf8]{inputenc}",
    "\\usepackage[T1]{fontenc}", "\\usetikzlibrary{calc}",
    "\\usepackage{amssymb}"))
	tikz(fileName, width = width, height = height, standAlone = TRUE,
    	packages = c("\\usepackage{tikz}",
	         "\\usepackage[active,tightpage,psfixbb]{preview}",
	         "\\PreviewEnvironment{pgfpicture}",
	         "\\setlength\\PreviewBorder{0pt}",
	         "\\usepackage{amssymb}"))


par(mfrow=c(nrow,ncol))

for (index in 1:length(params)){


	
		
	bias = numeric(0)

	p = params[index]


	sub.df = wcss.df[wcss.df$param == p,]
	
	if (nrow(sub.df) == 0){
		next
	}


	means = sub.df$mean
	lowers = sub.df$lower
	uppers = sub.df$upper
	truths = sub.df$truth
	sampleNums = sub.df$sample

	xymin = 0
	xymax = max(c(means, truths))*1.2
	if (p == "popMean" | p == "popSize.1") {
		#means = means[-1]
		#lowers = lowers[-1]
		#uppers = uppers[-1]
		#xymax = 0.05
	}

	if (params.show[index]){
		plot(0,0, type="n", xlim=c(xymin, xymax), ylim=c(xymin, xymax), main=params.latex[[p]], xlab="True value", ylab="Posterior estimate", axes=F, xaxs="i", yaxs="i", cex.lab=1.5, cex.main=1.8)
	
		v = axis(1)
		axis(2, las=2)
		
		lines(c(0, max(v)), c(0, max(v)), lty="2525")
		# abline(0, 2, lty="2525")
	}

	ncovered = 0
	nsamples = 0
	failed = numeric(0)
	for (s in 1:length(means)){


		m = means[s]
		l = lowers[s]
		u = uppers[s] 
		t = truths[s]
		
		
		bias = c(bias, m/t)
		
		if (p == "TreeHeight.stacey"){
			#t = t*2
		}
	

		if (length(t) == 0){
			next
		}

		covered = t > l & t < u

		if (params.show[index]){
			lines(c(t,t), c(l, u), col=ifelse(covered, "#800080", "#f58c00"))
			points(t, m, pch=16)
		}

		if (covered) {
			ncovered = ncovered + 1
		}else{
			failed = c(failed, sampleNums[s])
			
		}
		nsamples = nsamples + 1






	}

	if (params.show[index]){
		mtext(paste0("Coverage: ", signif(ncovered/nsamples*100, 3), "\\%"), cex=1.12)
	}

	cat(paste(p, " has a coverage of ", signif(ncovered/nsamples*100, 3), "%. The following failed:", paste(failed, collapse=","), "\n"))


	bias = log(bias)
	bias = mean(bias)
	bias = exp(bias)
	print(paste("The mean bias is", signif(bias), "\n"))

}







# Close file
dev.off()
tools::texi2pdf(fileName)


file.remove(fileName)
file.remove(gsub(".tex", ".log", fileName))
file.remove(gsub(".tex", ".aux", fileName))











