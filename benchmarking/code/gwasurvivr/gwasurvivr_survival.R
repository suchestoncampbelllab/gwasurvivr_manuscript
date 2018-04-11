library(batch)
library(gwasurvivr)

parseCommandArgs(evaluate=TRUE)

survFun <- function(impute.chunk,
                    sample.chunk,
                    covfile,
                    sample.ids,
                    outfile){

    impute.file <- impute.chunk
    sample.file <- sample.chunk
    chr <- 1
    covariate.file <- read.table(covfile, sep=" ", header=TRUE, stringsAsFactors = FALSE)
    sample.ids <- scan(sample.ids, what=character())
    time.to.event <- "time"
    event <- "event"
    covariates <- c("age", "sex", "bmiOVWT")
    out.file <- outfile
    maf.filter <- 0.005
    info.filter <- 0.1
    flip.dosage <- TRUE
    verbose <- TRUE
    
    impute2CoxSurv(impute.file,
                   sample.file,
                   chr,
                   covariate.file,
                   sample.ids,
                   time.to.event,
                   event,
                   covariates,
                   out.file,
                   maf.filter,
                   info.filter,
                   flip.dosage,
                   verbose)
}

survFun(impute.chunk,
        sample.chunk,
        covfile,
        sample.ids,
        outfile)


