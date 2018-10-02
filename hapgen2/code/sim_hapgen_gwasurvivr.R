setwd("/gwasurvivr_manuscript/hapgen2/code/")

library(tidyverse)

################################################################################
#### Less hit chr ##############################################################
hits <- read_csv("hits.csv", col_names =  FALSE)
no_hit <- read_csv("nonHitChr.csv", col_names =  FALSE)
head(no_hit)

add_no_hit <- 
    separate(X2, "pos") %>%
    mutate(hit = "1 1 1") %>%
    unite(X2, -X1, sep = " ")
    
no_hit %>%
bind_rows(add_no_hit) %>%
    arrange(X1) %>%
    write_csv("nonHitChr.csv",col_names = FALSE)

hits %>%
    filter(!X1 %in% c(10, 14, 6:9)) %>%
    write_csv("HitChr.csv",col_names = FALSE)
    
################################################################################

################################################################################
#### Generate sample files #####################################################

sample_head <- read.table(text="ID_1 ID_2 missing pheno
0 0 0 B", header=TRUE)

sample_df <- data.frame(
    ID_1= as.character(
        c(paste0("CONT", 1:6000),
          paste0("CASE", 1:3000))
        ),
    ID_2= as.character(
        c(paste0("CONT", 1:6000),
          paste0("CASE", 1:3000))
    ),
    missing = "0",
    pheno = as.character(c(rep(0, 6000), rep(1, 3000)))
)

sample_file <- rbind(sample_head, sample_df)
write.table(sample_file, "/gwasurvivr_manuscript/hapgen2/code/simulated.sample",
            quote = FALSE, row.names = FALSE)
