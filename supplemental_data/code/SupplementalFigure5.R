library(tidyverse)

all_chr_gwas <- readRDS("full_gwas_experiments/results/all_chr_times.rds")

all_chr_gwas %>%
    mutate(Atime = Total_Time-User_Time) %>%
    select(Ctime= User_Time,
           Atime,
           n=`Sample Size`,
           chr) %>%
    gather(`Step of Analysis`, Time, Atime, Ctime) %>%
    mutate(`Step of Analysis`=recode(`Step of Analysis`,
                                     Atime= "Survival Analysis",
                                     Ctime= "IMPUTE2 to GDS Compression"),
           Time=Time/3600) %>%
    ggplot(aes(chr, Time, fill=`Step of Analysis`, label=round(Time, 2))) +
    geom_col() + 
    # ggtitle("Time for full GWAS to complete: gwasurvivr") +
    ggtitle("gwasurvivr Runtimes for full GWAS across chromosomes") +
    scale_fill_manual(values = plot_cols[3:4]) +
    geom_text(size = 3, position = position_stack(vjust = 0.5), color="white") +
    theme_bw() +
    facet_grid(n~.) +
    scale_x_continuous(breaks=1:22) +
    theme(plot.title = element_text(size=18),
          axis.text.x = element_text(size=14),
          axis.text.y = element_text(size=14),
          axis.title.x = element_text(size=16),
          axis.title.y = element_text(size=16),
          legend.text = element_text(size=12),
          strip.text.x = element_text(size=14),
          legend.position="top",
          legend.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()
    ) +
    labs(x="Chromosome", y="Runtime (hours)") -> suppFig5

pdf("figures/Supplementary_Figure5.pdf", 
    width = 12, height = 10)
suppFig5
dev.off()


