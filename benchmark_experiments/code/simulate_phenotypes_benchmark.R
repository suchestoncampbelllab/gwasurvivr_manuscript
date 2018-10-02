## generate simulated phenotype data
library(tidyverse)
### generate sample files ####
n_generate <- function(n){
    data.frame(
        ID_1 = 0,
        ID_2 = "0",
        missing = 0,
        sex = 0,
        stringsAsFactors = FALSE
    ) %>%
        bind_rows(data.frame(
            ID_1 = 1:n,
            ID_2 = paste0("sample", 1:n),
            missing = c(-9) ,
            sex = c(2),
            stringsAsFactors = FALSE
        )) %>%
        write.table(
            paste0("/gwasurvivr_manuscript/benchmark_experiments/data/input/impute/sample_files/n", n, ".chr18.impute_sample"),
            sep = " ",
            row.names = FALSE,
            quote = FALSE
        )
}

sapply(c(100, 1000, 5000), n_generate)

#### generate sample_ids ####
### sample id dir
myDir <- "/gwasurvivr_manuscript/benchmark_experiments/data/input/impute/sample_ids/"
for(n in c(100, 1000, 5000)){
    paste0("sample", 1:n) %>%
        write.table(paste0(myDir, "sample_ids_n", n, ".txt"),
                    sep="\n", row.names = FALSE, quote = FALSE, col.names = FALSE)
}

#### generate simulated pheno files #####
set.seed(3456)
sim_dead <- data.frame(event=1,
                       time=abs(round(rnorm(2000, 4, sd=2.2), 2)),
                       age=round(rnorm(2000, 60, sd=4), 2),
                       DrugTxYes=sample(c(0,1),
                                        size = 2000,
                                        replace = TRUE,
                                        prob = c(0.3, 0.7)),
                       sex=sample(c(0,1), 
                                  size = 2000,
                                  replace = TRUE,
                                  prob = c(0.6, 0.40)))

sim_alive <- data.frame(event=0,
                        time=sample(c(4.3, 6.7, 8.8, 12),
                                    size = 3000,
                                    replace = TRUE,
                                    prob = c(0.05, 0.05, 0.05, 0.85)),
                        age=round(rnorm(3000, 40, sd=4), 2),
                        DrugTxYes=sample(c(0,1),
                                         size = 3000, 
                                         replace = TRUE,
                                         prob = c(0.9, 0.1)),
                        sex=sample(c(0,1), 
                                   size = 3000,
                                   replace = TRUE,
                                   prob = c(0.6, 0.40))
)

bind_rows(sim_dead, sim_alive) %>% 
    sample_n(5000) %>%
    mutate(ID_1=1:5000,
           ID_2=paste0("sample", 1:5000)) %>% 
    select(ID_1, ID_2, event:sex) -> sim_pheno

# write.table(sim_pheno, 
#             "/gwasurvivr_manuscript/benchmark_experiments/data/input/impute/covariates/simulated_pheno.txt",
#             sep = " ",
#             row.names = FALSE,
#             quote = FALSE)
# write_rds(sim_pheno,
#           "/gwasurvivr_manuscript/benchmark_experiments/data/input/impute/covariates/simulated_pheno.rds")

### generate phenotype files for genipe and survivr ####
sim_pheno <- read_rds("/gwasurvivr_manuscript/benchmark_experiments/data/input/impute/covariates/simulated_pheno.rds")
for(n in c(100, 1000, 5000)){
    sim_pheno %>%
        slice(1:n) %>%
        select(-ID_1) %>%
        mutate(sex=sex+1) %>%
        write.table(paste0("/gwasurvivr_manuscript/benchmark_experiments/data/input/impute/covariates/n", n, "_cov.phenotype"),
                    sep="\t", row.names = FALSE, quote = FALSE)
}
#### generate GWASTools files ####
# sim_pheno <- read_rds("/gwasurvivr_manuscript/benchmark_experiments/data/input/impute/covariates/simulated_pheno.rds")
for(n in c(100, 1000, 5000)){
    lapply(sim_pheno, as.character) %>% 
        data.frame() %>%
        slice(1:n) %>%
        mutate(missing="-9") %>% 
        select(ID_1, ID_2, missing, sex, event, time, age, DrugTxYes) %>% 
        bind_rows(data.frame(ID_1="0", 
                             ID_2="0", 
                             missing="0",
                             sex="D",
                             event="B", 
                             time="P", 
                             age="C",
                             DrugTxYes="D",
                             stringsAsFactors = FALSE), .) %>%
        write.table(paste0("/gwasurvivr_manuscript/benchmark_experiments/data/input/impute/gt_samples/n", n, "_chr18.impute.sample_gt"),
                    sep=" ", row.names = FALSE, quote = FALSE)
}
#### generate sv_samples files ####
# sim_pheno <- read_rds("/gwasurvivr_manuscript/benchmark_experiments/data/input/impute/covariates/simulated_pheno.rds")
for(n in c(100, 1000, 5000)){
    sim_pheno %>%    
        slice(1:n) %>%
        mutate(missing="-9") %>% 
        select(ID_1, ID_2, missing, sex, event, time, age, DrugTxYes) %>% 
        write.table(paste0("/gwasurvivr_manuscript/benchmark_experiments/data/input/impute/sv_samples/n", n, "_chr18.impute.sample_sv"),
                    sep=" ", row.names = FALSE, quote = FALSE)
}

