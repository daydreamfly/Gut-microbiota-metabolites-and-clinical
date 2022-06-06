library(mediation)
library(openxlsx)
data <- read.xlsx(paste("Data/","Data_for_mediation.xlsx", sep = ""))
data <- data.frame(data[,c(1:2)], apply(data[,-c(1:2)], 2, function(x) x = x*1000/sum(x, na.rm = T)))
data <- data[-which(rowSums(is.na(data)) > 0),] 
mod.metabo <- lm(paste("Metabo"," ~ ","Bac", sep = ""), data = data)
mod.indir<- lm(paste("Cli", "~", "Metabo", "+", "Bac", sep = ""), data = data)
mod.med = mediate(mod.metabo, mod.indir, treat = "Bac", mediator = "Metabo", sims = 10000)
summary(mod.med)
