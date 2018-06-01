## pulling all results
library(tidyverse)

options(scipen=100000)
setwd("~/GoogleDrive/OSU_PHD/benchmark_survivr/full_results/")

makeNum <- function(x){
    x %>%
        str_extract("[0-9]+") %>%
        as.numeric()
}


## gwasurvivr
sr_raw <- read_tsv("gwasurvivr_combined.txt")

sr <- sr_raw %>% 
    mutate(MAF=ifelse(exp_freq_A1>0.5, 1-exp_freq_A1, exp_freq_A1)) %>%
    separate(analysis, c("n_samp", "p_snp", "rep"), sep="_") %>%
    mutate_at(.vars=c("n_samp",
                    "p_snp",
                    "rep"),
              .funs=makeNum) %>%
    mutate(software="gwasurvivr")

head(sr)

sim_df_sp %>%
    filter(stats=="PVALUE") %>%
    ggplot(aes(x=gwasurvivr)) +
    geom_histogram(binwidth=0.05, fill="white", color="black") +
    facet_wrap(~sims, nrow=3, scales="free_y") +
    theme_bw()


sr %>% filter(PVALUE<5e-08) %>% nrow

sr %>%
    group_by(n_samp, p_snp, rep) %>%
    summarize(n=n())

## genipe
genipe_raw <- read_tsv("genipe_combined.txt")

genipe <- genipe_raw %>%
    dplyr::rename(TYPED=chr,
           POS=pos,
           RSID=snp,
           COEF=coef,
           SE.COEF=se,
           PVALUE=p,
           MAF=maf) %>% 
    mutate(CHR=1) %>%
    filter(MAF > 0.005,
           MAF < 0.995) %>%
    separate(analysis, c("n_samp", "p_snp", "rep"), sep="_") %>%
    mutate_at(.vars=c("n_samp",
                      "p_snp",
                      "rep"),
              .funs=makeNum) %>%
    mutate(software='genipe') %>%
    na.omit()

head(genipe)

genipe %>%
    group_by(n_samp, p_snp, rep) %>%
    summarize(n=n()) %>%
    print(n=Inf)

### gwastools
gwastools_raw <- read_tsv("gwastools_combined.txt")

gwastools <- gwastools_raw %>%
    dplyr::rename(RSID=snpID,
           CHR=chr,
           COEF=Est,
           SE.COEF=SE,
           Z=z.Stat, 
           PVALUE=z.pval) %>%
    filter(MAF > 0.005,
           MAF < 0.995)  %>%
    separate(analysis, c("n_samp", "p_snp", "rep"), sep="_") %>%
    mutate_at(.vars=c("n_samp",
                      "p_snp",
                      "rep"),
              .funs=makeNum) %>%
    mutate(software="GWASTools") %>%
    na.omit()




gwastools %>%
    group_by(n_samp, p_snp, rep) %>%
    summarize(n=n())

### SurvivalGWAS_SV
sv_raw <- read_tsv("sv_combined.txt")
sv <- sv_raw %>%
    dplyr::rename(TYPED=InputName,
           RSID=rsid,
           CHR=Chr,
           POS=Pos,
           COEF=CoefValue,
           SE.COEF=SE,
           HR_lowerCI=LowerCI,
           HR_upperCI=UpperCI,
           INFO=Infoscore,
           PVALUE=Waldpv) %>%
    filter(INFO > 0.7,
           MAF>0.005,
           MAF<0.995) %>%
    separate(analysis, c("n_samp", "p_snp", "rep"), sep="_") %>%
    mutate_at(.vars=c("n_samp",
                      "p_snp",
                      "rep"),
              .funs=makeNum) %>%
    mutate(software='SurvivalGWAS_SV')



cols <- c("RSID", "MAF", "COEF", "PVALUE", "software", "n_samp", "p_snp", "rep")
data <- do.call("rbind", list(sr[,cols], sv[,cols], gwastools[,cols], genipe[,cols]))
data <- data %>%
    as_tibble()

data <- data %>% filter(rep==1)

data <- data %>% 
    unite(sims, n_samp, p_snp, sep="_")

data <- data %>%
    group_by(software, sims, RSID) %>%
    summarize_at(.vars=c("MAF", "COEF", "PVALUE"),
                 funs(mean=mean(., na.rm=TRUE))) %>%
    dplyr::rename(MAF=MAF_mean,
           COEF=COEF_mean,
           PVALUE=PVALUE_mean)

#data %>% group_by(sims) %>% summarize(n=n())    


sim_df_sp <- data %>%
    gather(key="stats","value",MAF:PVALUE) %>% 
    unite(grp, -value, remove = FALSE) %>%
    filter(!duplicated(grp)) %>%
    dplyr::select(-grp) %>%
    spread(software, value) %>%
    na.omit() 

sim_df_sp$sims <- as.factor(sim_df_sp$sims)
sim_df_sp$sims <- sim_df_sp$sims %>%
    fct_relevel("100_1000", "100_10000", "100_100000")
sim_df_sp$sims <- sim_df_sp$sims %>%
    recode("100_1000"="n=100, p=1000",
           "100_10000"="n=100, p=10000",
           "100_100000"="n=100, p=100000",
           "1000_1000"="n=1000, p=1000",
           "1000_10000"="n=1000, p=10000",
           "1000_100000"="n=1000, p=100000",
           "5000_1000"="n=5000, p=1000",
           "5000_10000"="n=5000, p=10000",
           "5000_100000"="n=5000, p=100000")


# saveRDS(sim_df_sp, 
#         file="~/GoogleDrive/OSU_PHD/benchmark_survivr/full_results/simulation_results_all_software.rds")



sim_df_sp %>% 
    group_by(sims) %>%
    summarise(n())



library(tidyverse)
library(patchwork)
library(ggsci)

sim_df_sp <- readRDS("~/GoogleDrive/OSU_PHD/benchmark_survivr/full_results/simulation_results_all_software.rds")

coef <- sim_df_sp %>%
    filter(stats=="COEF") %>%
    gather(key = "analysis", "value", c(genipe, GWASTools, SurvivalGWAS_SV)) %>% 
    filter(value > -3, value < 3) %>%
    mutate(value=ifelse(value<0, abs(value), value),
           gwasurvivr=ifelse(gwasurvivr<0, abs(gwasurvivr), gwasurvivr)) %>%  
    ggplot(aes(x=gwasurvivr, y=value, color=analysis)) +
    geom_point() +
    facet_wrap(~sims, scales="free") +
    ggtitle("Coefficients") + 
    labs(x="gwasurvivr coefficient estimates", y="other software cofficient estimates") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5)) +
    scale_color_npg()
    
coef

pval <- sim_df_sp %>%
    filter(stats=="PVALUE") %>%
    gather(key = "analysis", "value", c(genipe, GWASTools, SurvivalGWAS_SV)) %>% 
    ggplot(aes(x=gwasurvivr, y=value, color=analysis)) +
    geom_point() +
    facet_wrap(~sims, scales="free") +
    ggtitle("P-values") +
    labs(x="gwasurvivr P-values", y="Other software P-values") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), legend.position="none") +
    #theme(plot.title = element_text(hjust = 0.5)) +
    scale_color_npg() 

pval

maf <- sim_df_sp %>%
    filter(stats=="MAF") %>%
    gather(key = "analysis", "value", c(genipe, GWASTools, SurvivalGWAS_SV)) %>% 
    ggplot(aes(x=gwasurvivr, y=value, color=analysis)) +
    geom_point() +
    theme(plot.title = element_text(hjust = 0.5), legend.position="none") +
    facet_wrap(~sims, scales="free") +
    ggtitle("Minor Allele Frequency (MAF)") +
    labs(x="gwasurvivr MAFs", y="Other software MAF") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), legend.position="none") +
    #theme(plot.title = element_text(hjust = 0.5)) +
    scale_color_npg() 

maf




coef

(maf | pval | coef)
