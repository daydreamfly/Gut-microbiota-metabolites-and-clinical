Custom code related to the original research article "XXXXX". 

We published the essential codes of the work here to help others to review or replicate our findings.

The microbiome composition and metabolic MetaCyc pathways were obtained through open-source bioBakery tools, MetaPhlAn and HUMAnN (https://huttenhower.sph. harvard.edu/tools/) for fecal shotgun metagenomics sequencing, open-source QIIME (http://qiime.org) for fecal 16S rDNA amplicon sequencing. The untargeted serum metabolome profile was preprocessed and achieved by open-source XCMS (https://git.bioconductor.org/packages/xcms). These mentioned tools used for the data analysis were applied with default parameters. 

Metagenomics sequence data supporting the findings of this study have been deposited in the European Nucleotide Archive (accession codes: PRJAN812318 and PRJNA812695), with public access. Metabolomics data were uploaded to Metabolights (accession numbers: MTBL1809).
Instructions
R dependent packages (Windows/Mac/Linux system)
lme4

rmcorr

mediation

DirichletMultinomial 
Software (Windows system)
SMICA (Umeå, Sweden)

All the R packages could be installed by open-source R software. The SMICA software should be purchased from Umetrics, Sweden.
Descriptions
The key analysis in our study can be grouped into 5 major categories:

** 1. linear mixed model **

“LMM.R” is a script for investigating the relative abundance changes of metabolites over time.

** 2. Rmcorr Correlation analysis **

“Rmcorr.R” is a script for investigating the common association between metabolites and clinical indexes within each subject.

** 3. Mediation analysis **

“Mediation.R” is a script for investigating the associations between predictor and mediator and the associations among predictor, mediator, and outcome.

** 4. Dirichlet multinomial mixture model**

“DMM.R” is a script for investigating the community type of each fecal metagenomic sample.

** 5. OPLS model **

“OPLS.md” is a tutorial for the OPLS model.
