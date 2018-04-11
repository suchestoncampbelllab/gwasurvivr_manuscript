library(tidyverse)
options("width"=100)
setwd("~/Google Drive/OSU_PHD/benchmark_survivr/")

options(scipen=1000000)
gwastools <- map(dir("./timeData/", pattern="gwastools", full.names = TRUE), read_tsv) %>%
    bind_rows() %>%
    dplyr::select(-jobid, -node)

genipe <- read_tsv("./timeData/genipe_times_compiled.txt") %>%
    dplyr::select(-jobid, -node)

sv <- map(dir("./timeData/", pattern="sv", full.names = TRUE), read_tsv) %>%
    bind_rows() %>%
    dplyr::select(-array.inc,-rep.sec.sum) %>%
    dplyr::rename(seconds=mean.sec)

sr <- map(dir("./timeData/", pattern="gwasurvivr", full.names = TRUE), read_tsv) %>%
    bind_rows() %>%
    dplyr::select(-jobid, -node)

full <- bind_rows(gwastools, genipe, sv, sr)
time <- full %>% 
    dplyr::select(-rep) %>%
    group_by(analysis, n_samp, p_snp) %>%   
    summarise_all(funs(mean(., na.rm=TRUE),
                       sd(., na.rm=TRUE),
                       se=sd(.)/sqrt(n()),
                       lowerCI=mean-(1.96*se),
                       upperCI=mean+(1.96*se))
                  ) %>%
    ungroup() %>%
    mutate(n_samp=paste("n=", n_samp, sep=""),
           p_snp=paste("p=", p_snp), sep="") %>%
    ggplot(aes(x=factor(n_samp), y=mean, color=analysis, group=analysis)) +
    geom_errorbar(aes(ymin = lowerCI, ymax = upperCI), width = 0.1) +
    geom_point(size=1) +
    geom_line() +
    facet_grid(~p_snp, scales="free_y") +
    scale_y_log10() +
    labs(y=expression(paste("-log"[10], plain(minutes))), x="Sample Sizes") +
    ggtitle("Runtime for Survival Analysis") +
    scale_color_npg() +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5)) 
    

