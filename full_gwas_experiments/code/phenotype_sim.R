library(tidyverse)
library(magrittr)

samp_ids <- read_delim("simulated.sample", delim = " ") %$% ID_1 
length(samp_ids)
head(samp_ids)
samp_ids <- samp_ids[-1]
samp_ids[6000:6001]

sim_case <- data.frame(event=1,
                       time=abs(round(rnorm(3000, 4, sd=2.2), 2)),
                       age=round(rnorm(3000, 60, sd=4), 2),
                       DrugTxYes=sample(c(0,1),
                                        size = 3000,
                                        replace = TRUE,
                                        prob = c(0.3, 0.7)),
                       sex=sample(c(0,1), 
                                  size = 3000,
                                  replace = TRUE,
                                  prob = c(0.6, 0.40)))

sim_control <- data.frame(event=0,
                        time=sample(c(4.3, 6.7, 8.8, 12),
                                    size = 6000,
                                    replace = TRUE,
                                    prob = c(0.01, 0.03, 0.05, 0.85)),
                        age=round(rnorm(6000, 40, sd=4), 2),
                        DrugTxYes=sample(c(0,1),
                                         size = 3000, 
                                         replace = TRUE,
                                         prob = c(0.9, 0.1)),
                        sex=sample(c(0,1), 
                                   size = 6000,
                                   replace = TRUE,
                                   prob = c(0.6, 0.40))
)

bind_rows(sim_control, sim_case) %>% 
    mutate(IDs = samp_ids) %>%
    write_tsv("sim_pheno_N9K.txt")
