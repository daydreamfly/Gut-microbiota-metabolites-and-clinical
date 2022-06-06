setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(rmcorr)
library(openxlsx)
rm(list = ls())

metabo.cli <- read.xlsx(paste("Data/","Data_for_rmcorr.xlsx", sep = ""))
metabo.cli$variable <- as.factor(metabo.cli$variable)

result.r <- matrix(NA, nrow = (ncol(metabo.cli) - 5), ncol = 3)
result.p <- matrix(NA, nrow = (ncol(metabo.cli) - 5), ncol = 3)
rownames(result.r) <- colnames(metabo.cli)[c(6:ncol(metabo.cli))]
colnames(result.r) <- colnames(metabo.cli)[c(3:5)]
rownames(result.p) <- rownames(result.r)
colnames(result.p) <- colnames(result.r)

for(m in 3:5){ #3:14
  for(n in 6:ncol(metabo.cli)){   #start = 15
    model <- rmcorr(participant = "variable", measure1 = colnames(metabo.cli)[m], measure2 = colnames(metabo.cli)[n], dataset = metabo.cli, CIs = "bootstrap")
    result.r[colnames(metabo.cli)[n], colnames(metabo.cli)[m]] <- model$r
    result.p[colnames(metabo.cli)[n], colnames(metabo.cli)[m]] <- model$p
  }
}
write.table(result.p, paste("Results/","Rmcorr.p.txt", sep = ""))
write.table(result.r,paste("Results/","Rmcorr.r.txt", sep = ""))


