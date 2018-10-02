## generate simulated phenotype data
library(tidyverse)

#### generate simulated pheno files #####
set.seed(3456)

sim_survival <- function(n_dead, n_alive, out.path){
    sim_dead <- data.frame(event=1,
                           time=abs(round(rnorm(n_dead, 4, sd=2.2), 2)),
                           age=round(rnorm(n_dead, 60, sd=4), 2),
                           DrugTxYes=sample(c(0,1),
                                            size = n_dead,
                                            replace = TRUE,
                                            prob = c(0.3, 0.7)),
                           sex=sample(c(0,1), 
                                      size = n_dead,
                                      replace = TRUE,
                                      prob = c(0.6, 0.40)))
    
    sim_alive <- data.frame(event=0,
                            time=sample(c(runif(round(n_alive/100), min = 0, max = 12), 
                                          rep(12, n_alive-round(n_alive/100))),
                                        size = n_alive,
                                        replace = FALSE),
                            age=round(rnorm(n_alive, 40, sd=4), 2),
                            DrugTxYes=sample(c(0,1),
                                             size = n_alive, 
                                             replace = TRUE,
                                             prob = c(0.9, 0.1)),
                            sex=sample(c(0,1), 
                                       size = n_alive,
                                       replace = TRUE,
                                       prob = c(0.6, 0.40))
    )
    
    bind_rows(sim_dead, sim_alive) %>%
        mutate(ID_1 = c(paste0("CASE", 1:n_dead),
                        paste0("CONT", 1:n_alive)
        ),
        ID_2=paste0("sample", 1:(n_dead+n_alive))) %>% 
        select(ID_1, ID_2, event:sex) %>%
        write.table(file = out.path, sep="\t", row.names = FALSE, quote = FALSE)
    
}

Ns <- read_csv("/gwasurvivr_manuscript/largeN_experiments/code/Ns_15K_20K_25K.csv", 
               col_names = c("Ns", "case", "cont"))

for(i in seq_len(nrow(Ns))){
    n_dead <- Ns$case[i]
    n_alive <-Ns$cont[i]
    out.path <- paste0("/gwasurvivr_manuscript/largeN_experiments/data/pheno_files/N",Ns$Ns[i], "K_pheno.txt")
    
    sim_survival(n_dead, n_alive, out.path)
    
}