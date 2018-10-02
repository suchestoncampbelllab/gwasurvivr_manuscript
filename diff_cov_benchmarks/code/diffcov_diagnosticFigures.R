
library(tidyverse)
library(patchwork)
library(ggsci)

cov_df_sp <- readRDS("/gwasurvivr_manuscript/diff_cov_benchmarks/results/diff_covs_results_all_software.rds")

coef <- cov_df_sp %>%
    filter(stats=="COEF") %>%
    gather(key = "analysis", "value", c(genipe, GWASTools, SurvivalGWAS_SV)) %>% 
    filter(value > -3, value < 3) %>%
    mutate(value=ifelse(value<0, abs(value), value),
           gwasurvivr=ifelse(gwasurvivr<0, abs(gwasurvivr), gwasurvivr)) %>%  
    ggplot(aes(x=gwasurvivr, y=value, color=analysis)) +
    geom_point() +
    facet_wrap(~covnum, scales="free") +
    ggtitle("Coefficients") + 
    labs(x="gwasurvivr coefficient estimates", y="other software cofficient estimates") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5)) +
    scale_color_npg()

coef


pval <- cov_df_sp %>%
    filter(stats=="PVALUE") %>%
    gather(key = "analysis", "value", c(genipe, GWASTools, SurvivalGWAS_SV)) %>% 
    ggplot(aes(x=gwasurvivr, y=value, color=analysis)) +
    geom_point() +
    facet_wrap(~covnum, scales="free") +
    ggtitle("P-values") +
    labs(x="gwasurvivr P-values", y="Other software P-values") +
    theme_bw() +
    #    theme(plot.title = element_text(hjust = 0.5), legend.position="none") +
    scale_color_npg() 

pval

maf <- cov_df_sp %>%
    filter(stats=="MAF") %>%
    gather(key = "analysis", "value", c(genipe, GWASTools, SurvivalGWAS_SV)) %>% 
    ggplot(aes(x=gwasurvivr, y=value, color=analysis)) +
    geom_point() +
    theme(plot.title = element_text(hjust = 0.5), legend.position="none") +
    facet_wrap(~covnum, scales="free") +
    ggtitle("Minor Allele Frequency (MAF)") +
    labs(x="gwasurvivr MAFs", y="Other software MAF") +
    theme_bw() +
    #    theme(plot.title = element_text(hjust = 0.5), legend.position="none") +
    scale_color_npg() 

maf
