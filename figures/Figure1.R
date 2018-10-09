library(tidyverse)
library(glue)
options(scipen=1000000)
## multi-paneled figure

plot_cols <- c("#21313E","#20726E","#67B675","#EFEE69")[4:1]


#############################################
### A. load in benchmarking comparisons #####

times <- readRDS("benchmark_experiments/results/times/benchmark_experiments_times.rds")
sv_times <- readRDS("benchmark_experiments/results/times/sv_arrays.rds")
head(sv_times)

sv_times %>%
    group_by(n,m,repnum) %>%
    summarise(seconds=max(seconds)) %>%
    ungroup() %>%
    filter(m==1e5) %>%
    group_by(n, m) %>%
    summarise(mean = mean(seconds),
              sd=sd(seconds)) %>%
    ungroup() %>%
    mutate(se= sd/sqrt(3),
           upperCI=mean+1.96*se,
           lowerCI=mean-1.96*se,
           n=as.character(glue("n={n}")),
           m="m=100000",
           software = "SurvivalGWAS_SV*")-> svTimes_df


timesPlot <- times %>%
    filter(software != "SurvivalGWAS_SV") %>%
    bind_rows(svTimes_df) %>%
    mutate_at(vars(mean, lowerCI, upperCI), function(x) x/3600) %>%
    ggplot(aes(x=n, y=mean, group=software, color=software)) +
    geom_errorbar(aes(ymin = lowerCI, ymax =upperCI),
                  width = 0.05) +
    geom_point(size=1.2) +
    geom_line(size=1) +
    scale_color_manual(values = plot_cols,
                      labels=c(" genipe   ",
                               " GWASTools   ",
                               " gwasurvivr   ",
                               " SurvivalGWAS_SV\n(Rate limiting array)   ")) +
    labs(y="Runtime (hours)", x="Sample Sizes")+
    ggtitle("A.") +
    theme_bw() +
    theme(plot.title = element_text(size=18),
          axis.text.x = element_text(size=14),
          axis.text.y = element_text(size=14),
          axis.title.x = element_text(size=16),
          axis.title.y = element_text(size=16),
          strip.text.x = element_text(size=14),
          legend.text = element_text(size=12),
          legend.position="top",
          legend.title = element_blank(),
          legend.background = element_blank())  
timesPlot
#############################################

#############################################
### B. load in different covariate times ####
covs <- readRDS("diff_cov_benchmarks/results/times/diff_cov_times.rds")
sv_covs <- readRDS("diff_cov_benchmarks/results/times/sv_covs_expanded.rds")

sv_covs %>%
    group_by(n, m, covnum) %>%
    summarise(seconds=max(Seconds)) %>%
    ungroup() %>%
    mutate(software = "SurvivalGWAS_SV*")-> sv_df

covs %>%
    select(software, n, m, covnum,seconds) %>%
    filter(software != "SurvivalGWAS_SV") %>%
    bind_rows(sv_df) %>%
    mutate(seconds=seconds/3600) -> covs_pl

cov_plot <- covs_pl %>%
    ggplot(aes(factor(covnum), seconds, fill=software)) +
    geom_col(position = "dodge") +
    geom_text(aes(label=round(seconds,2)), 
              position=position_dodge(width=0.9), vjust=-0.25) +
    ggtitle("B.") +
    xlab("Number of covariates included in the model") +
    ylab("Runtime (hours)") +
    scale_fill_manual(values = plot_cols,
                      labels=c(" genipe   ",
                               " GWASTools   ",
                               " gwasurvivr   ",
                               " SurvivalGWAS_SV\n(Rate limiting array)   ")) +
    theme_bw() +
    theme(plot.title = element_text(size=18),
          axis.text.x = element_text(size=14),
          axis.text.y = element_text(size=14),
          axis.title.x = element_text(size=16),
          axis.title.y = element_text(size=16),
          legend.text = element_text(size=12),
          legend.key.size = unit(5, "mm"),
          strip.text.x = element_text(size=14),
          legend.position="top",
          legend.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()
          
    )

cov_plot
#############################################

#############################################
### C. load in big N times ####

big_N_times <- readRDS("largeN_experiments/results/big_N_times.rds")
bigN_plot <- 
    big_N_times %>%
    ggplot(aes(n, times, fill=Type, label=round(times, 2))) +
    geom_col() +
    scale_fill_manual(values = plot_cols[3:4]) +
    geom_text(size = 5, position = position_stack(vjust = 0.5), color="white") +
    ggtitle("C.") +
    ylab("Time (hours)") +
    xlab("Sample Sizes") +
    theme_bw() +
    theme( plot.title = element_text(size=18),
           axis.text.x = element_text(size=14),
           axis.text.y = element_text(size=14),
           axis.title.x = element_text(size=16),
           axis.title.y = element_text(size=16),
           legend.text = element_text(size=12),
           strip.text.x = element_text(size=14),
           legend.position=c(0.28,0.914),
           legend.box="vertical",
           legend.direction = "vertical",
           legend.title = element_blank(),
           panel.grid.major = element_blank(),
           panel.grid.minor = element_blank()
    ) +
    labs(x="Sample Sizes", y="Runtime (hours)")


bigN_plot
#############################################

############################################
### D. load in gwas times ####
gwas_times <- readRDS("full_gwas_experiments/results/gwas_times.rds")

gwasTimesPlot <- gwas_times %>%
    ggplot(aes(n, Time, fill=`Step of Analysis`, label=round(Time, 2))) +
    geom_col() + 
    ggtitle("D.") +
    scale_fill_manual(values = plot_cols[3:4]) +
    geom_text(size = 5, position = position_stack(vjust = 0.5), color="white") +
    theme_bw() +
    theme(plot.title = element_text(size=18),
          axis.text.x = element_text(size=14),
          axis.text.y = element_text(size=14),
          axis.title.x = element_text(size=16),
          axis.title.y = element_text(size=16),
          legend.text = element_text(size=12),
          strip.text.x = element_text(size=14),
          legend.position=c(0.28,0.914),
          legend.box="vertical",
          legend.direction = "vertical",
          legend.key = element_rect(colour = "transparent", fill = "white"),
          legend.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()
    ) +
    labs(x="Sample Sizes", y="Runtime (hours)")

gwasTimesPlot
############################################

############################################
#### PLOT ####
library(patchwork)

pdf("figures/Figure1.pdf", 
    width = 12, height = 10)
(timesPlot + cov_plot)  / (bigN_plot + gwasTimesPlot) 
dev.off()
############################################






