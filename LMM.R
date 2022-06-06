setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(lme4)
library(sjstats)
library(car)
options(stringsAsFactors = F, warn = -1)

data <- openxlsx::read.xlsx(paste("Data/","Data_for_LMM.xlsx", sep = ""))
index <- colnames(data)

result <- data.frame(p = numeric(),stringsAsFactors=FALSE)

for(j in 3:ncol(data)){
  run <- paste("lmer(",index[j]," ~ 1 + time + (1|SampleID)",",data = data,","control =lmerControl(check.nobs.vs.nlev = 'ignore',
     check.nobs.vs.rankZ = 'ignore',check.nobs.vs.nRE='ignore'))",sep="")
  model <- eval(parse(text = run))
  p <- Anova(model)$`Pr(>Chisq)`
  result[j-2,] <- p
  rownames(result)[j-2] <- index[j]
}
# openxlsx::write.xlsx(result, "LMM.result.xlsx", rowNames = T)
write.table(result, paste("Results/","LMM.result.txt", sep = ""))
