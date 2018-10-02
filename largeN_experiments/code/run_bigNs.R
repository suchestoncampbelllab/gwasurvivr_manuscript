library(gwasurvivr)
library(batch)

parseCommandArgs(evaluate=TRUE)

options("gwasurvivr.cores"=12L)

###############################################################################
###### imputeCoxSurv ########################################################

covariate.file <- read.table(covariate.file, sep="\t", header=TRUE, stringsAsFactors = FALSE)


impute2CoxSurv(impute.file=impute.file,
               sample.file=sample.file,
               chr=22,
               covariate.file=covariate.file,
               id.column="ID_1",
               sample.ids=NULL,
               time.to.event="time",
               event="event",
               covariates=c("age", "sex", "DrugTxYes"),
               inter.term=NULL,
               print.covs="only",
               out.file= out.file,
               chunk.size=10000,
               maf.filter=0.005,
               flip.dosage=TRUE,
               verbose=TRUE,
               keepGDS=TRUE,
               clusterObj=NULL)
