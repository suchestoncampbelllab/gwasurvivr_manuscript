# coxph_model.R
library(survival)
coxph_model <- function(SNP,
                        pheno.file,
                        time.to.event,
                        event,
                        covariates)
{
    formula <- paste0("Surv(time=",
                      time.to.event,
                      ", event=",
                      event,
                      ") ~ SNP + ",
                      paste(covariates, collapse=" + "))
    survFitMod <- function(SNP){
        res <- coxph(as.formula(formula), data=data.frame(pheno.file))   
        m <- summary(res)
        m <- c(m$coef[1,], n=m$n)
        return(m)
    }
    survFitMod(SNP)
}
