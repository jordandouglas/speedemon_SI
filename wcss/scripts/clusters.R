
if (!require(tikzDevice, quietly = T)) install.packages("tikzDevice")
library(tikzDevice)




posterior.df = data.frame(sample = character(0), support=numeric(0), posterior.cluster = character(0), true = logical(0))

reps = list.files("templates/", "rep*")
for (r in reps){


	if (!file.exists(paste0("templates/", r, "/posterior.clusters"))){
		next
	}
	
	
	print(r)


	true.clusters.in = readLines(paste0("templates/", r, "/true.clusters")) 
	posterior.clusters.in = readLines(paste0("templates/", r, "/posterior.clusters")) 


	# Find the true clusters
	true.start = grep("support\tcount\tcluster", true.clusters.in)+1
	#true.start = grep("support\t.taxa\tclusters", true.clusters.in)+1
	true.stop = which(true.clusters.in == "")
	true.stop = true.stop[true.stop > true.start][1]-1
	if (is.na(true.stop)) true.stop = length(true.clusters.in)
	true.clusters = sapply(strsplit(true.clusters.in[true.start:true.stop], "\t"), function(ele) ele[3])
	
	

	
	# Find the posterior clusters
	posterior.start = grep("support\tcount\tcluster", posterior.clusters.in)+1
	#posterior.start = grep("support\t.taxa\tclusters", posterior.clusters.in)+1
	posterior.stop = which(posterior.clusters.in == "")
	posterior.stop = posterior.stop[posterior.stop > posterior.start][1]-1
	if (is.na(posterior.stop)) posterior.stop = length(posterior.clusters.in)
	posterior.clusters = sapply(strsplit(posterior.clusters.in[posterior.start:posterior.stop], "\t"), function(ele) ele[3])
	posterior.clusters.support = as.numeric(gsub("%", "", sapply(strsplit(posterior.clusters.in[posterior.start:posterior.stop], "\t"), function(ele) ele[1])))

	
	
	# For each estimated cluster, find out if its true or not
	for (i in 1:length(posterior.clusters)){
	
		pc = posterior.clusters[i]
		support = posterior.clusters.support[i]
		
		
		# True?
		match = which(true.clusters == pc)	
		truth = length(match) > 0
		
		
		posterior.df2 = data.frame(sample = r, support=support, posterior.cluster = pc, true = truth)
		posterior.df = rbind(posterior.df, posterior.df2)
	
	
	}
	


}



# Hack to establish method
method = ifelse(length(grep("snapper", getwd()) > 0), "SNAPPER", "StarBeast3")

cols = c("#800080", "#f58c00")

png("clusterSupport.png", width=800, height = 800, res=150)

# Bins
NBINS = 20
bins = seq(from = 0, to = 100, length = NBINS+1)
pcorrect = rep(0, NBINS)


plot(0,0, type="n", xlim=c(0,100), ylim=c(0,100), xlab="Cluster posterior support (%)", ylab="Probability of the cluster being true (%)", main=method, axes=F, yaxs="i")

for(i in 1:NBINS){

	lower = bins[i]
	upper = bins[i+1]
	
	
	sub.df = posterior.df[posterior.df$support > lower & posterior.df$support <= upper,]
	sub.df = sub.df[!is.na(sub.df$support),]
	ntrue = sum(sub.df$true)
	nvals = nrow(sub.df)
	p = ntrue/nvals
	
	col = paste0(cols[i %% 2 + 1], "aa")
	col2 = "black"#cols[(i+1) %% 2 + 1]
	
	rect(lower, 0, upper, p*100, col=col)
	
	# binomial error
	lower2 = qbinom(p = 0.025, prob = p, size = nvals) / nvals * 100
	upper2 = qbinom(p = 0.975, prob = p, size = nvals)/nvals * 100
	
	pcorrect[i] = p
	
	
	m = mean(sub.df$support)
	lines(c(m,m), c(lower2, upper2), col=col2, lwd=2)
	points(m, p*100, pch=16, col=col2)
	#text((lower+upper)/2, 95, nvals, cex=0.5, srt=45)
	

}


abline(0,1)
grid()


axis(1)
axis(2, las=2)



dev.off()







