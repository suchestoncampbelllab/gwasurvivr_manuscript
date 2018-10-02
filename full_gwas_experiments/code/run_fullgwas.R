library(batch)
library(gwasurvivr)

parseCommandArgs(evaluate=TRUE)

options("gwasurvivr.cores"=as.numeric(ncores))


runCoxSurv <- function(impute.file, chr, sample.ids, out.file){
    covariate.file <- "/projects/rpci/lsuchest/ezgi/gwasurvivr_sims/covariate_file/sim_pheno_N9K.txt"
    covariate.file <- read.table(covariate.file,
                                 header=TRUE,
                                 sep="\t", 
                                 stringsAsFactors=FALSE)
    sample.ids <- scan(sample.ids, what=character())
    sample.file <- "/projects/rpci/lsuchest/ezgi/gwasurvivr_sims/sample_files/simulated.sample"
    impute2CoxSurv(impute.file=impute.file,
                   sample.file=sample.file,
                   chr=as.numeric(chr),
                   covariate.file=covariate.file,
                   id.column="IDs",
                   sample.ids=sample.ids,
                   time.to.event="time",
                   event="event",
                   covariates=c("age", "DrugTxYes", "sex"),
                   inter.term=NULL,
                   print.covs="only",
                   out.file=out.file,
                   chunk.size=10000,
                   maf.filter=0.05,
                   flip.dosage=TRUE,
                   verbose=TRUE,
                   clusterObj=NULL,
		   keepGDS = FALSE)
}

runCoxSurv(impute.file,
           chr,
           sample.ids,
           out.file)

