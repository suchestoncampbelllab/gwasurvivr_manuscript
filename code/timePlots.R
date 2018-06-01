library(tidyverse)

# save times data
times <- read.table("/data/full_results/timesPlotData.txt",
                    sep="\t",
                    header=TRUE,
                    stringsAsFactors = FALSE)

times %>%
    ggplot(aes(x=factor(n_samp), y=log10(mean), color=software, group=software)) +
    geom_errorbar(aes(ymin = log10(lowerCI), ymax = log10(upperCI)), width = 0.1) +
    geom_point(size=1) +
    geom_line() +
    facet_grid(~p_snp, scales="free_y") +
    labs(y=expression(paste("log"[10], plain(seconds))), x="Sample Sizes") +
    ggtitle("Runtime for Survival Analysis") +
    theme_bw() + 
    theme(plot.title = element_text(hjust = 0.5, size=18),
          axis.text.x = element_text(size=14),
          axis.text.y = element_text(size=14),
          axis.title.x = element_text(size=16),
          axis.title.y = element_text(size=16),
          legend.text = element_text(size=14),
          strip.text.x = element_text(size=14),
          legend.title = element_text(size=16))


