# supplementary figure 1
# source("/code/gcoxph_model.R")
# source("/code/coxph_model.R")

# load library
library(gwasurvivr)
# load phenotype data
pheno.file <- readRDS("~/Google Drive/OSU_PHD/gwasurvivr_manuscript/data/supplemental_data/simulated_pheno.rds")
sample.ids <- pheno.file$ID_2
# load genotype data
genotypes <- readRDS("~/Google Drive/OSU_PHD/gwasurvivr_manuscript/data/supplemental_data/sanger.genotypes.rds")

library(microbenchmark)
library(survival)
tm <- microbenchmark(
    gws_1cov=t(apply(X=genotypes,
                     MARGIN=1,
                     FUN=gcoxph_model,
                     pheno.file=pheno.file, 
                     time.to.event="time", 
                     event="event", 
                     covariates="age", 
                     sample.ids=sample.ids)),
    gws_2cov=t(apply(X=genotypes,
                     MARGIN=1,
                     FUN=gcoxph_model,
                     pheno.file=pheno.file, 
                     time.to.event="time", 
                     event="event", 
                     covariates=c("age", "DrugTxYes"), 
                     sample.ids=sample.ids)),
    gws_3cov=t(apply(X=genotypes,
                     MARGIN=1,
                     FUN=gcoxph_model,
                     pheno.file=pheno.file, 
                     time.to.event="time", 
                     event="event", 
                     covariates=c("age", "DrugTxYes", "SexFemale"), 
                     sample.ids=sample.ids)) ,
    surv_1cov=t(apply(X=genotypes,
                      MARGIN=1,
                      FUN=coxph_model,
                      pheno.file=pheno.file,
                      time.to.event="time",
                      event="event",
                      covariates="age")),
    surv_2cov=t(apply(X=genotypes,
                      MARGIN=1,
                      FUN=coxph_model,
                      pheno.file=pheno.file,
                      time.to.event="time",
                      event="event",
                      covariates=c("age", "DrugTxYes"))),
    surv_3cov=t(apply(X=genotypes,
                      MARGIN=1,
                      FUN=coxph_model,
                      pheno.file=pheno.file,
                      time.to.event="time",
                      event="event",
                      covariates=c("age", "DrugTxYes", "SexFemale"))),
    times=3L,
    unit = "s"
)
tm

df <- read.table(text = "
      simulation      min       lower_quartile     mean   median       upper_quartile      max 
                 gws_1cov 27.11076 29.61483 30.90848 32.11891 32.80734 33.49577
                 gws_2cov 32.38955 33.28182 33.73240 34.17409 34.40383 34.63356
                 gws_3cov 35.04497 35.97687 36.34055 36.90877 36.98835 37.06793
                 surv_1cov 44.94886 45.83481 46.15520 46.72077 46.75837 46.79598
                 surv_2cov 46.87313 47.12968 49.65251 47.38622 51.04220 54.69818
                 surv_3cov 51.51329 52.32482 53.89750 53.13635 55.08960 57.04286", header=TRUE)



df %>% 
    separate(simulation, c("simulation", "covs")) %>% 
    mutate(simulation=recode(simulation, gws="gcoxph (gcoxph_model.R)", surv="coxph (coxph_model.R)"),
           covs=str_extract(covs, "[[:digit:]]+")) %>% 
    ggplot(aes(simulation, mean, fill=covs)) + 
    geom_col(position = position_dodge(), width = 0.5) +
    geom_errorbar(aes(ymin = min, ymax = max), position = position_dodge(width = 0.5), width = 0.1, size=0.5)+
    scale_fill_brewer(palette = "Purples") + theme_bw() +
    ylab("Mean Seconds") +
    xlab("Survival Functions Tested") +
    guides(fill = guide_legend("Number of\nCovariates")) +
    ggtitle("Run time comparison using gcoxph models and \n standard coxph models considering 1, 2 and 3 covariates") +
    theme(plot.title = element_text(hjust = 0.5)) 
