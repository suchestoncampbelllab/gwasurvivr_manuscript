library(gwasurvivr)
library(batch)

parseCommandArgs(evaluate=TRUE)

options("gwasurvivr.cores"=as.numeric(ncores))


surv <- function(impute.chunk,
                 sample.chunk,
                 covariate.file,
                 sample.ids,
                 output,
                 chunk.size, 
                 covariate){
    
    if(covariate=="cov4"){
        covariates <- c("age", "sex", "DrugTxYes", "pc1")
    } else if(covariate=="cov8"){
        covariates <- c("age", "sex", "DrugTxYes", "pc1", "pc2", "pc3", "pc4", "pc5")
    } else if(covariate=="cov12"){
        covariates <- c("age", "sex", "DrugTxYes", "pc1", "pc2", "pc3", "pc4", "pc5", "pc6", "pc7", "pc8", "pc9")
    }
    
    covariate.file <- read.table(covariate.file, header=TRUE, sep="\t", stringsAsFactors=FALSE)
    
    sample.ids <- scan(sample.ids, what=character())
    
    impute2CoxSurv(impute.file=impute.chunk,
                   sample.file=sample.chunk,
                   chr=18,
                   covariate.file=covariate.file,
                   id.column="ID_2",
                   sample.ids=sample.ids,
                   time.to.event="time",
                   event="event",
                   covariates=covariates,
                   inter.term=NULL,
                   print.covs="only",
                   out.file=output,
                   chunk.size=chunk.size,
                   maf.filter=0.005,
                   flip.dosage=TRUE,
                   verbose=TRUE,
                   clusterObj=NULL,
                   keepGDS=FALSE)
}

surv(impute.chunk,
     sample.chunk,
     covariate.file,
     sample.ids,
     output,
     as.numeric(chunk.size),
     covariate)
