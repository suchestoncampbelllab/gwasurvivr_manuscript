#gcoxph_model.R
library(survival)
gcoxph_model <- function(SNP,
                   pheno.file,
                   time.to.event,
                   event,
                   covariates,
                   sample.ids)
{
    n.sample <- nrow(pheno.file)
    n.event <- sum(as.numeric(pheno.file[, event]))
    # fit Cox model using survival::Surv
    # first manually set up input arguments for survival:::coxph.fit
    Y <- Surv(time = pheno.file[, time.to.event],
              event = pheno.file[, event])
    rownames(Y) <- as.character(seq_len(nrow(Y)))
    STRATA <- NULL
    CONTROL <- structure(
        list(
            eps = 1e-09,
            toler.chol = 1.81898940354586e-12,
            iter.max = 20L,
            toler.inf = 3.16227766016838e-05,
            outer.max = 10L,
            timefix = TRUE
        ),
        .Names = c("eps",
                   "toler.chol",
                   "iter.max",
                   "toler.inf",
                   "outer.max",
                   "timefix")
    )
    OFFSET <- NULL
    WEIGHTS <- NULL
    METHOD <- "efron"
    ROWNAMES <- sample.ids
    
    # if no covariates -- fit model with no intiial points
    if (is.null(covariates)) {
        INIT <- NULL
        pheno.file <- matrix(pheno.file[, covariates], ncol = 1)
        pheno.file <- NULL
        # if covariates are equal to 1 start with parameters already fit with just the covariates 
        ## (and maintain a matrix object)
    } else if (length(covariates) == 1L) {
        pheno.file <- matrix(pheno.file[, covariates], ncol = 1)
        colnames(pheno.file) <- covariates
        INIT <- NULL
        init.fit <- coxph.fit(pheno.file,
                              Y,
                              STRATA,
                              OFFSET,
                              INIT,
                              CONTROL,
                              WEIGHTS,
                              METHOD,
                              ROWNAMES)
        INIT <- c(0,  init.fit$coefficients)
        # else if covariates are greater than 1 - initialize fit with covariate estimates alone  
    } else {
        pheno.file <- as.matrix(pheno.file[, covariates])
        INIT <- NULL
        init.fit <- coxph.fit(pheno.file,
                              Y,
                              STRATA,
                              OFFSET,
                              INIT,
                              CONTROL,
                              WEIGHTS,
                              METHOD,
                              ROWNAMES)
        INIT <- c(0,  init.fit$coefficients)
    }
    if(is.null(pheno.file)){
        X <- matrix(SNP, ncol = 1)
    }else{
        ## creating model matrix
        X <- cbind(SNP, pheno.file)
    }
    if(is.null(pheno.file)){
        X <- matrix(SNP, ncol = 1)
    }else{
        ## creating model matrix
        X <- cbind(SNP, pheno.file)
    }    
    ## run fit with pre-defined parameters including INIT
    fit <- coxph.fit(X,
                     Y,
                     STRATA,
                     OFFSET,
                     INIT, 
                     CONTROL,
                     WEIGHTS,
                     METHOD, 
                     ROWNAMES)
    ## extract statistics
    coef <- fit$coefficients[1]
    serr <- sqrt(diag(fit$var)[1])
    cox.out <- cbind(coef=coef, serr=serr)
    # calculate z-score
    z <- cox.out[,1]/cox.out[,2]
    # calculate p-value
    pval <- 2*pnorm(abs(z), lower.tail=FALSE)
    # calculate hazard ratio
    hr <- exp(cox.out[,1])
    # putting everything back together
    sres <- cbind(cox.out[,1], hr, cox.out[,2], z, pval, n.sample, n.event)
    colnames(sres) <- c("COEF",
                        "HR",
                        "SE.COEF",
                        "Z",
                        "PVALUE",
                        "N", 
                        "NEVENT")
    rownames(sres) <- NULL 
    return(sres)
}
