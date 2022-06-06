library("vegan")
library("ggplot2")
library("parallel")
library("reshape2")
library("DirichletMultinomial")

dat_tab <- "Data/genus.pr"
output_dir <- "Results/genus"

#----------

dat_taxa <- read.table(dat_tab,header = T ,row.names = 1,sep="\t",check.names=F)

#########
counts <- dat_taxa*100000
counts <- as.matrix(counts)
count_1 <- t(counts)

set.seed(0)

fit <- mclapply(1:5, dmn, count=count_1, verbose=TRUE, seed = 1)
lplc <- sapply(fit, laplace)

##Model Fit figure.
pdf(paste0(output_dir,"_model.Fit.pdf"))
plot(lplc, type="b", xlab="Number of Dirichlet Components", ylab="Fit")
dev.off()

############################################
best <- fit[[which.min(lplc)]]

coll <- mixture(best)
col <- apply(coll,1,which.max)
col <- data.frame(ID = names(col),cluster = col)

#NMDS plot
swiss.x <- dat_taxa
swiss.x <- sweep(swiss.x,2,apply(swiss.x,2,sum),"/")

#set.seed(0)

swiss.mds <- metaMDS(t(swiss.x))
swiss <- data.frame(ID = rownames(swiss.mds$points),swiss.mds$points)
swiss <- merge(swiss,col,by = "ID",sort = F)
swiss$cluster <- as.factor(swiss$cluster)

fill_color <- c( "#fdc086","#386cb0", "#f0027f","#7fc97f","#beaed4",
                 "#fdc086","#386cb0", "#f0027f","#7fc97f","#beaed4")

p1 <- ggplot(swiss,aes(MDS1,MDS2,color = cluster)) + 
        theme_bw() +
        geom_point() +
        scale_color_manual(values = fill_color) +
        theme(panel.grid = element_blank()) +
        labs(title = "NMDS")

ggsave(paste0(output_dir,"_NMDS.plot.pdf"),p1,w =6, h = 5)

############################################
tax_dat <- as.data.frame(apply(dat_taxa,2, function(x) x/sum(x)))

tax_dat$Sum <- rowSums(tax_dat)
tax_dat <- tax_dat[order(tax_dat$Sum,decreasing = T),]
tax_dat <- tax_dat[,-ncol(tax_dat)]

if(dim(tax_dat)[1]>10){
  tax_dat <- tax_dat[1:10,]
}

tax_dat_1 <- log10(tax_dat+1e-2)
tax_dat_1 <- melt(as.matrix(tax_dat_1))

names(tax_dat_1) <- c("tax","ID","value")
tax_dat_1 <- merge(tax_dat_1,col,by = "ID",sort = F)
tax_dat_1$cluster <-  factor(tax_dat_1$cluster)

p2 <- ggplot(tax_dat_1,aes(cluster,value,fill = cluster)) +
        stat_boxplot(geom="errorbar",width = 0.3) +
		geom_boxplot(outlier.size = 0.5,outlier.alpha = 0.5)+
        theme_bw() +
        ylim(min(tax_dat_1$value),max(tax_dat_1$value)) +
        scale_fill_manual(values = fill_color) +
        labs(x = "",y = "Relative abundance(log10)") +
        theme(legend.position = "",
              panel.grid  = element_blank()
        ) +
        facet_wrap(.~tax,ncol = 5,scales = "free_y")
LE <- max(nchar(as.character(tax_dat_1$tax)))
w = length(levels(tax_dat_1$cluster)) * 3 + 4 + LE*0.08
ggsave(paste0(output_dir,"_Top.10.abundance_taxa.pdf"), p2, width = w, height = 6)

############################################
best_1 <- fitted(best)
best_dat <- melt(best_1)
colnames(best_dat) <- c("Tax", "cluster", "value")

L <- c()
PT <- list()
for (i in seq(ncol(fitted(best)))) {
  cluster_dat <- subset(best_dat,cluster == i)
  cluster_dat <- cluster_dat[order(cluster_dat$value,decreasing = T),]
  cluster_dat$Tax <- factor(cluster_dat$Tax ,levels = rev(unique(cluster_dat$Tax)))
  
  if(dim(cluster_dat)[1]>10){
	cluster_dat <- cluster_dat[1:10,]
  }
  tax <- cluster_dat$Tax[which.max(cluster_dat$value)]
  L<- c(L,as.character(tax))
  p <- ggplot(cluster_dat, aes(x = Tax, y = value)) +
    	geom_bar(stat = "identity") +
    	coord_flip() +
    	theme_bw() +
    	labs(x = "",title = paste0("Top drivers of community type: cluster ",i)) +
    	theme(panel.grid.minor.y = element_blank(),
          	panel.grid.major.y = element_blank(),
          	panel.grid.minor.x = element_line(linetype = "dashed"),
          	panel.grid.major.x = element_line(linetype = "dashed")
    	) +
    	theme(axis.text = element_text(color = "black"))
  ggsave(paste0(output_dir,"_cluster_",i,".pdf"),p,w = 7,height = 3)
}

