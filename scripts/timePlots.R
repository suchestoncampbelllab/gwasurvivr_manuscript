library(tidyverse)


makeNum <- function(x){
    x %>%
        str_extract("[0-9]+") %>%
        as.numeric()
}

# sv_rep1
sv_times_rep1 <- read_tsv("~/Google Drive/OSU_PHD/benchmark_survivr/timeData/sv_times_rep1.txt",
                          col_names=FALSE)



sv_rep1 <- sv_times_rep1 %>%
    separate(X1, c("software",
                   "n_samp",
                   "p_snp",
                   "rep",
                   "jobid",
                   "arraynum"),
             sep='_') %>% 
    mutate_at(.vars=c("n_samp", "p_snp", "rep", "jobid","arraynum", "X3"),
              .funs=makeNum) %>%
    mutate(X2=str_replace(X2, "SLURM_JOB_NODELIST=", "")) %>%
    dplyr::rename(seconds=X3,
                  nodelist=X2) %>% 
    arrange(n_samp, p_snp, rep, jobid, arraynum) %>% 
    group_by(n_samp, p_snp, rep) %>% 
    summarize(cum.sec=sum(seconds),
              mean.sec=mean(seconds),
              array.total=n()) %>%
    mutate(software="SurvivalGWAS_SV")

# sv_rep2
sv_times_rep2 <- read_tsv("~/Google Drive/OSU_PHD/benchmark_survivr/timeData/sv_times_rep2.txt",
                          col_names=FALSE)

sv_rep2 <- sv_times_rep2 %>%
    separate(X1, c("software",
                   "n_samp",
                   "p_snp",
                   "rep",
                   "jobid",
                   "arraynum"),
             sep='_') %>% 
    mutate_at(.vars=c("n_samp", "p_snp", "rep", "jobid","arraynum", "X3"),
              .funs=makeNum) %>%
    mutate(X2=str_replace(X2, "SLURM_JOB_NODELIST=", "")) %>%
    dplyr::rename(seconds=X3,
                  nodelist=X2) %>% 
    arrange(n_samp, p_snp, rep, jobid, arraynum) %>% 
    group_by(n_samp, p_snp, rep) %>% 
    summarize(cum.sec=sum(seconds),
              mean.sec=mean(seconds),
              array.total=n()) %>%
    mutate(software="SurvivalGWAS_SV")

# sv_rep3
sv_times_rep3 <- read_tsv("~/Google Drive/OSU_PHD/benchmark_survivr/timeData/sv_times_rep3.txt",
                          col_names=FALSE)

sv_rep3 <- sv_times_rep3 %>%
    separate(X1, c("software",
                   "n_samp",
                   "p_snp",
                   "rep",
                   "jobid",
                   "arraynum"),
             sep='_') %>% 
    mutate_at(.vars=c("n_samp", "p_snp", "rep", "jobid","arraynum", "X3"),
              .funs=makeNum) %>%
    mutate(X2=str_replace(X2, "SLURM_JOB_NODELIST=", "")) %>%
    dplyr::rename(seconds=X3,
                  nodelist=X2) %>% 
    arrange(n_samp, p_snp, rep, jobid, arraynum) %>% 
    group_by(n_samp, p_snp, rep) %>% 
    summarize(cum.sec=sum(seconds),
              mean.sec=mean(seconds),
              array.total=n()) %>%
    mutate(software="SurvivalGWAS_SV")

sv_tot <- bind_rows(sv_rep1, sv_rep2, sv_rep3)

# gwasurvivr 
gwasurvivr <- read_tsv("~/Google Drive/OSU_PHD/benchmark_survivr/timeData/gwasurvivr_times.txt", col_names=FALSE)
gwasurvivr %>% head
dim(gwasurvivr)
gws <- gwasurvivr %>%
    mutate(X1=str_replace(X1, ".out", ""),
           X2=str_replace(X2, "SLURM_JOB_NODELIST=", "")) %>%
    separate(X1, c("n_samp", "p_snp", "rep", "jobid"), sep="_") %>%
    mutate_at(.vars=c("X3"),
              .funs=makeNum) %>%
    rename(seconds=X3,
           nodelist=X2) %>%
    unite(simulation, c("n_samp", "p_snp", "rep")) %>%
    arrange(simulation, jobid) %>%
    group_by(simulation) %>%
    filter(duplicated(simulation) | n()==1) %>%
    mutate(software="gwasurvivr") %>%
    separate(simulation, c("n_samp", "p_snp", "rep"), sep="_") %>%
    mutate_at(.vars=c("n_samp", "p_snp", "rep", "jobid"),
              .funs=makeNum) %>%
    arrange(n_samp, p_snp, rep)
gws

# genipe 
genipe <- read_tsv("~/Google Drive/OSU_PHD/benchmark_survivr/timeData/genipe_times_20180517.txt", col_names=FALSE)

genipe <- genipe %>%
    mutate(X1=str_replace(X1, ".out", ""),
           X2=str_replace(X2, "SLURM_JOB_NODELIST=", "")) %>%
    separate(X1, c("software","n_samp", "p_snp", "rep", "jobid"), sep="_") %>%
    mutate_at(.vars=c("X3", "n_samp", "p_snp", "rep", "jobid"),
              .funs=makeNum) %>%
    rename(seconds=X3) %>%
    arrange(n_samp, p_snp, rep) 


# gwastools
gwastools <- read_tsv("~/Google Drive/OSU_PHD/benchmark_survivr/timeData/gwastools_times.txt", col_names=FALSE)
gwastools <- gwastools %>%
    mutate(X1=str_replace(X1, ".out", ""),
           X2=str_replace(X2, "SLURM_JOB_NODELIST=", ""),
           software="GWASTools") %>%
    separate(X1, c("n_samp", "p_snp", "rep", "jobid"), sep="_") %>% 
    mutate_at(.vars=c("n_samp", "p_snp", "rep", "jobid", "X3"),
              .funs=makeNum) %>%
    rename(nodelist=X2,
           seconds=X3) %>%
    arrange(n_samp, p_snp, rep)


sv_plot <- sv_tot %>%
    select(n_samp, p_snp, rep, cum.sec, software) %>%
    rename(seconds=cum.sec)
gws_plot <- gws %>%
    select(n_samp, p_snp, rep, seconds, software)

genipe_plot <- genipe %>%
    select(n_samp, p_snp, rep, seconds, software)

gwtools_plot <- gwastools %>%
    select(n_samp, p_snp, rep, seconds, software)

full <- bind_rows(sv_plot, gws_plot, genipe_plot, gwtools_plot)

options(scipen=100000)
# plot
full %>%
    select(-rep) %>%
    group_by(software, n_samp, p_snp) %>%     
    summarise_all(funs(mean(., na.rm=TRUE),
                       sd(., na.rm=TRUE),
                       se=sd(.)/sqrt(n()),
                       lowerCI=mean-(1.96*se),
                       upperCI=mean+(1.96*se))
    ) %>% 
    ungroup() %>% 
    mutate(n_samp=paste("n=", n_samp, sep=""),
           p_snp=paste("p=", p_snp, sep="")) %>%
    ggplot(aes(x=factor(n_samp), y=log10(mean), color=software, group=software)) +
    geom_errorbar(aes(ymin = log10(lowerCI), ymax = log10(upperCI)), width = 0.1) +
    geom_point(size=1) +
    geom_line() +
    facet_grid(~p_snp, scales="free_y") +
   # scale_y_log10() +
    labs(y=expression(paste("log"[10], plain(seconds))), x="Sample Sizes") +
    ggtitle("Runtime for Survival Analysis") +
    theme_bw() + 
    theme(plot.title = element_text(hjust = 0.5))


# save times data
times <- full %>%
    select(-rep) %>%
    group_by(software, n_samp, p_snp) %>%     
    summarise_all(funs(mean(., na.rm=TRUE),
                       sd(., na.rm=TRUE),
                       se=sd(.)/sqrt(n()),
                       lowerCI=mean-(1.96*se),
                       upperCI=mean+(1.96*se))
    ) %>% 
    ungroup() %>% 
    mutate(n_samp=paste("n=", n_samp, sep=""),
           p_snp=paste("p=", p_snp, sep=""))

# write.table(times,
#             file="~/Google Drive/OSU_PHD/benchmark_survivr/timeData/timesPlotData.txt",
#             sep="\t",
#             quote=FALSE,
#             row.names=FALSE,
#             col.names=TRUE)
