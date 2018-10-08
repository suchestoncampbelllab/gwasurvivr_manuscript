library(tidyverse)
options(scipen=1000000)
## multi-paneled figure

#######################
## load in gwas times
gwas_times <- readRDS("full_gwas_experiments/results/gwas_times.rds")

gwasTimesPlot <- gwas_times %>%
    ggplot(aes(n, Time, fill=`Step of Analysis`, label=round(Time, 2))) +
    geom_col() + 
    # ggtitle("Time for full GWAS to complete: gwasurvivr") +
    ggtitle("D.") +
    scale_fill_manual(values = plot_cols[3:4]) +
    geom_text(size = 5, position = position_stack(vjust = 0.5), color="white") +
    theme_bw() +
    #guides(fill = guide_legend(direction = "horizontal")) +
    theme(plot.title = element_text(size=18),
          axis.text.x = element_text(size=14),
          axis.text.y = element_text(size=14),
          axis.title.x = element_text(size=16),
          axis.title.y = element_text(size=16),
          legend.text = element_text(size=12),
          strip.text.x = element_text(size=14),
          legend.position=c(0.28,0.91),
          legend.box="vertical",
          legend.direction = "vertical",
          #legend.background = element_rect(colour = NA),
          legend.key = element_rect(colour = "transparent", fill = "white"),
          legend.title = element_blank()) +
    labs(x="Sample Sizes", y="Runtime (hours)")

gwasTimesPlot
######################
## load in big N times

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
          legend.position=c(0.28,0.91),
          legend.box="vertical",
          legend.direction = "vertical",
          legend.title = element_blank()) +
    labs(x="Sample Sizes", y="Runtime (hours)")


bigN_plot

##################
## load in different covariate times


plot_cols <- c("#21313E","#20726E","#67B675","#EFEE69")[4:1]

covs <- readRDS("diff_cov_benchmarks/results/times/diff_cov_times.rds")

cov_plot <- covs %>%
    ggplot(aes(factor(covnum), seconds/3600, fill=software)) +
    geom_col(position = "dodge") +
    geom_text(aes(label=round(seconds/3600,2)), position=position_dodge(width=0.9), vjust=-0.25) +
    #ggtitle("Different covariates runtimes (n=5000, m=100K SNPs)") +
    ggtitle("B.") +
    xlab("Number of covariates included in the model") +
    ylab("Time (hours)") +
    scale_fill_manual(values = plot_cols) +
    theme_minimal() +
    theme(plot.title = element_text(size=18),
          axis.text.x = element_text(size=14),
          axis.text.y = element_text(size=14),
          axis.title.x = element_text(size=16),
          axis.title.y = element_text(size=16),
          legend.text = element_text(size=12),
          legend.key.size = unit(5, "mm"),
          strip.text.x = element_text(size=14),
          legend.position=c(0.2,0.8),
          legend.box="vertical",
          legend.direction = "vertical",
          legend.title = element_blank()
    )

cov_plot

##################################
### load in benchmarking comparisons

times <- readRDS("benchmark_experiments/results/times/benchmark_experiments_times.rds")

timesPlot <- times %>%
    ggplot(aes(x=n, y=log10(mean), group=software, color=software)) +
    geom_errorbar(aes(ymin = log10(lowerCI), ymax = log10(upperCI)),
                  width = 0.05) +
    geom_point(size=0.8) +
    geom_line(size=0.8) +
    scale_color_manual(values = plot_cols) +
    labs(y="Seconds", x="Number of markers")+
    labs(y=expression(paste("log"[10], plain(seconds))), x="Sample Sizes") +
    ggtitle("A.") +
    theme_minimal() +
    theme(plot.title = element_text(size=18),
          axis.text.x = element_text(size=14),
          axis.text.y = element_text(size=14),
          axis.title.x = element_text(size=16),
          axis.title.y = element_text(size=16),
          strip.text.x = element_text(size=14),
          legend.text = element_text(size=12),
          legend.position=c(0.2,0.8),
          legend.box="vertical",
          legend.direction = "vertical",
          legend.title = element_blank())  
timesPlot


# timesPlot

#### PLOT ####
library(patchwork)

pdf("figures/Figure1.pdf", 
    width = 12, height = 10)
(timesPlot + cov_plot)  / (bigN_plot + gwasTimesPlot) 
dev.off()
####






