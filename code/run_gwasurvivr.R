library(gwasurvivr)
library(batch)

parseCommandArgs(evaluate=TRUE)

options("gwasurvivr.cores"=as.numeric(ncores))

surv <- function(impute.chunk,
		 sample.chunk,
		 covariate.file,
		 sample.ids,
		 output,
		 chunk.size){

	covariate.file <- read.table(covariate.file, header=TRUE, sep=" ", stringsAsFactors=FALSE)

	sample.ids <- scan(sample.ids, what=character())

	impute2CoxSurv(impute.file=impute.chunk,
				   sample.file=sample.chunk,
				   chr=18,
				   covariate.file=covariate.file,
				   id.column="ID_2",
				   sample.ids=sample.ids,
				   time.to.event="time",
				   event="event",
				   covariates=c("age", "sex", "DrugTxYes"),
				   inter.term=NULL,
				   print.covs="only",
				   out.file=output,
				   chunk.size=chunk.size,
				   maf.filter=0.005,
				   info.filter=0.1,
				   flip.dosage=TRUE,
				   verbose=TRUE,
				   clusterObj=NULL)
}

surv(impute.chunk,
     sample.chunk,
     covariate.file,
     sample.ids,
     output,
     as.numeric(chunk.size))
