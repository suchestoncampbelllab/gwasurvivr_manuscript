library(tidyverse)
Ns <- read_csv("code/Ns_15K_20K_25K.csv",
               col_names = c("nsize", "cases", "controls"))
Ns

samp_top <- read.table(text = "ID_1 ID_2 missing pheno
0 0 0 B")

for(i in seq_len(nrow(Ns))){
    ids <- c("0", 
             paste0("CONT", seq_len(Ns$controls[i])),
             paste0("CASE", seq_len(Ns$cases[i]))
             )
    pheno <- c(0, 
               rep(0, Ns$controls[i]),
               rep(1, Ns$cases[i])
               )
    data.frame(ID_1=ids,
               ID_2=ids,
               missing=0,
               pheno=pheno) %>%
        write_delim(path = paste0("sample_files/",
                  "N_", Ns$nsize[i], "K.sample"), delim =" ")
}

