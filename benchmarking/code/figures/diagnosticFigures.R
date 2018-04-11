## pulling all results
library(tidyverse)
setwd("~/Google Drive/OSU_PHD/benchmark_survivr/full_results/")

sr_raw <- read_tsv("gwasurvivr_all_reps.txt")

sr <- sr_raw %>% 
    mutate(MAF=ifelse(exp_freq_A1>0.5, 1-exp_freq_A1, exp_freq_A1))

sr %>%
    group_by(n_samp, p_snp) %>%
    summarize(n=n())


genipe_raw <- read_tsv("genipe_all_reps.txt")

genipe <- genipe_raw %>%
    rename(TYPED=chr,
           POS=pos,
           RSID=snp,
           COEF=coef,
           SE.COEF=se,
           PVALUE=p,
           MAF=maf) %>% 
    mutate(CHR=1) %>%
    filter(MAF > 0.005,
           MAF < 0.995) %>%
    na.omit()

head(genipe)




genipe %>%
    group_by(n_samp, p_snp) %>%
    summarize(n=n())


gwastools_raw <- read_tsv("gwastools_all_reps.txt")

gwastools <- gwastools_raw %>%
    rename(RSID=snpID,
           CHR=chr,
           COEF=Est,
           SE.COEF=SE,
           Z=z.Stat, 
           PVALUE=z.pval) %>%
    filter(MAF > 0.005,
           MAF < 0.995) %>%
    na.omit()

gwastools %>%
    group_by(n_samp, p_snp) %>%
    summarize(n=n())



sv_raw <- read_tsv("sv_all_reps.txt")
sv <- sv_raw %>%
    rename(TYPED=InputName,
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
           MAF<0.995)



cols <- c("RSID", "MAF", "COEF", "PVALUE", "analysis", "n_samp", "p_snp", "rep")
data <- do.call("rbind", list(sr[,cols], sv[,cols], gwastools[,cols], genipe[,cols]))
data <- data %>%
    as_tibble()

data <- data %>% 
    unite(sims, n_samp, p_snp, sep="_")

data <- data %>%
    group_by(analysis, sims, RSID) %>%
    summarize_at(.vars=c("MAF", "COEF", "PVALUE"),
                 funs(mean=mean(., na.rm=TRUE))) %>%
    rename(MAF=MAF_mean,
           COEF=COEF_mean,
           PVALUE=PVALUE_mean)

#data %>% group_by(sims) %>% summarize(n=n())    


sim_df_sp <- data %>%
    gather(key="stats","value",MAF:PVALUE) %>% 
    unite(grp, -value, remove = FALSE) %>%
    filter(!duplicated(grp)) %>%
    select(-grp) %>%
    spread(analysis, value) %>%
    na.omit() 

sim_df_sp$sims <- as.factor(sim_df_sp$sims)
sim_df_sp$sims <- sim_df_sp$sims %>% fct_relevel("100_1000", "100_10000", "100_100000")



sim_df_sp %>% 
    group_by(sims) %>%
    summarise(n())


#### coef ####

sim_df_sp %>%
    filter(stats=="COEF") %>%
    gather(key = "analysis", "value", c(genipe, gwastools, survivalgwasSV)) %>% 
    filter(value > -3, value < 3) %>%
    ggplot(aes(x=gwasurvivr, y=value, color=analysis)) +
    geom_point(alpha=0.5) +
    # coord_cartesian(xlim = c(-3,3), ylim = c(-3,3))+
    facet_grid(analysis~sims, scales="free_x") +
    ggtitle("Software Coefficients") + 
    labs(x="gwasurvivr coefficient estimates", y="other software cofficient estimates")


sim_df_sp %>%
    filter(stats=="PVALUE") %>%
    gather(key = "analysis", "value", c(genipe, gwastools, survivalgwasSV)) %>% 
    ggplot(aes(x=gwasurvivr, y=value, color=analysis)) +
    geom_point(alpha=0.5) +
    facet_wrap(~sims, scales="free") +
    ggtitle("Correlation of Other Survival Packages P-values Against gwasurvivr") +
    labs(x="gwasurvivr P-values", y="Other software P-values")

sim_df_sp %>%
    filter(stats=="MAF") %>%
    gather(key = "analysis", "value", c(genipe, gwastools, survivalgwasSV)) %>% 
    ggplot(aes(x=gwasurvivr, y=value, color=analysis)) +
    geom_point(alpha=0.5) +
    facet_wrap(~sims, scales="free") +
    ggtitle("Correlation of Other Survival Packages MAFs Against gwasurvivr") +
    labs(x="gwasurvivr MAFs", "Other package MAF")


