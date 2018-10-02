## correlation plots
library(tidyverse)
options("width"=180)
options(scipen = 10000000)

makeNum <- function(x){
    x %>%
        str_extract("[0-9]+") %>%
        as.numeric()
}

######################
# different covariates
######################
# gwasurvivr
gwasurv_names <-  dir(path="./diff_cov_benchmarks/results/gwasurvivr/", pattern="coxph")
gwasurv_reps <- dir(path="./diff_cov_benchmarks/results/gwasurvivr/", pattern="coxph", full.names=TRUE) %>%
    map(read_tsv)

gwasurv_reps <- mapply(function(x, analysis) x %>% mutate(analysis=analysis), gwasurv_reps, gwasurv_names, SIMPLIFY = FALSE) %>%
    bind_rows() %>%
    mutate(analysis=str_replace(analysis, ".coxph", "")) %>%
    separate(analysis, c("n", "m", "covnum", "software")) %>%
    mutate_at(.vars=c("n", "m", "covnum"), .funs=makeNum)  %>%
    rename(MAF=SAMP_MAF)

# genipe
genipe_names <-  dir(path="./diff_cov_benchmarks/results/genipe/", pattern="cox.dosage")
genipe_reps <- dir(path="./diff_cov_benchmarks/results/genipe/", pattern="cox.dosage", full.names=TRUE) %>%
    map(read_tsv)

genipe_reps <- mapply(function(x, analysis) x %>% mutate(analysis=analysis), genipe_reps, genipe_names, SIMPLIFY = FALSE) %>%
    bind_rows() %>%
    mutate(analysis=str_replace(analysis, ".cox.dosage", "")) %>%
    separate(analysis, c("n", "m", "covnum", "software")) %>%
    mutate_at(.vars=c("n", "m", "covnum"), .funs=makeNum) 

genipe_reps <- genipe_reps %>%
    dplyr::rename(TYPED=chr,
                  POS=pos,
                  RSID=snp,
                  COEF=coef,
                  SE.COEF=se,
                  PVALUE=p,
                  MAF=maf) %>% 
    mutate(CHR=18) %>%
    filter(MAF > 0.005,
           MAF < 0.995) %>%
    na.omit()

genipe_reps %>%
    group_by(n, m, covnum) %>%
    summarize(count=n())


# gwastools
gwastools_names <-  dir(path="./diff_cov_benchmarks/results/gwastools/", pattern="gwastools")
gwastools_reps <- dir(path="./diff_cov_benchmarks/results/gwastools/", pattern="gwastools", full.names=TRUE) %>%
    map(read_delim, delim=" ")

gwastools_reps <- mapply(function(x, analysis) x %>% mutate(analysis=analysis), gwastools_reps, gwastools_names, SIMPLIFY = FALSE) %>%
    bind_rows() %>% 
    separate(analysis, c("n", "m", "covnum", "software")) %>%
    mutate_at(.vars=c("n", "m", "covnum"), .funs=makeNum) 

gwastools_reps <- gwastools_reps %>%
    dplyr::rename(RSID=snpID,
                  CHR=chr,
                  COEF=Est,
                  SE.COEF=SE,
                  Z=z.Stat, 
                  PVALUE=z.pval) %>%
    filter(MAF > 0.005,
           MAF < 0.995) %>%
    mutate(software=str_replace(software, "gwastools", "GWASTools"))

gwastools_reps %>%
    group_by(n, m, covnum) %>%
    summarize(count=n())

# sv
# combine sv 
sv_names <- dir(path="./diff_cov_benchmarks/results/sv/", ".txt")
sv_reps <- dir(path="./diff_cov_benchmarks/results/sv/", pattern="sv", full.names=TRUE) %>%
    map(read_tsv) %>%
    bind_rows() %>%
    mutate(analysis=str_replace(analysis, "survivalgwasSV", "SurvivalGWAS_SV")) %>%
    rename(software=analysis) %>%
    dplyr::rename(TYPED=InputName,
                  RSID=rsid,
                  CHR=Chr,
                  POS=Pos,
                  COEF=CoefValue,
                  SE.COEF=SE,
                  HR_lowerCI=LowerCI,
                  HR_upperCI=UpperCI,
                  INFO=Infoscore,
                  PVALUE=Waldpv,
                  n=n_samp,
                  m=p_snp) %>%
    filter(INFO > 0.7,
           MAF>0.005,
           MAF<0.995) 


## merge
cols <- c("RSID", "MAF", "COEF", "PVALUE", "software", "n", "m", "covnum")
data <- do.call("rbind", list(gwasurv_reps[,cols], sv_reps[,cols], gwastools_reps[,cols], genipe_reps[,cols]))
data <- data %>%
    as_tibble()


data <- data %>% 
    unite(sims, n, m, sep="_")

data <- data %>%
    group_by(software, covnum, RSID) %>%
    summarize_at(.vars=c("MAF", "COEF", "PVALUE"),
                 funs(mean=mean(., na.rm=TRUE))) %>%
    dplyr::rename(MAF=MAF_mean,
                  COEF=COEF_mean,
                  PVALUE=PVALUE_mean)

cov_df_sp <- data %>%
    gather(key="stats","value",MAF:PVALUE) %>% 
    unite(grp, -value, remove = FALSE) %>%
    filter(!duplicated(grp)) %>%
    dplyr::select(-grp) %>%
    spread(software, value) %>%
    na.omit() 

cov_df_sp$covnum <- as.factor(cov_df_sp$covnum)
cov_df_sp$covnum <- cov_df_sp$covnum %>%
    fct_relevel("4", "8", "12")

# saveRDS(cov_df_sp,
#         file="./diff_cov_benchmarks/results/diff_covs_results_all_software.rds")

cov_df_sp %>% 
    group_by(covnum) %>%
    summarise(n())

library(tidyverse)
library(patchwork)
library(ggsci)

cov_df_sp <- readRDS("./diff_cov_benchmarks/results/diff_covs_results_all_software.rds")

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
