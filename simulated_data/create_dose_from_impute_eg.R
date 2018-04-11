library(tidyverse)
library(data.table)
library(matrixStats)

# read in probabilities
genProb <- fread("~/GoogleDrive/OSU_PHD/gwasurvivr/inst/extdata/impute_example.impute2")

# read in iids
iids <- read.table("~/GoogleDrive/OSU_PHD/gwasurvivr/inst/extdata/impute_example.impute2_sample", skip=2, stringsAsFactors = FALSE)[,2]


# generate the snp column with snp ids and imputation (I) or typed (T) info
snpData <- genProb[,1:5] 
snp <- snpData %>%
    mutate(V1=ifelse(V1=="---", "I", "T")) %>%
    unite(snp, V2, V1, sep=".") %>% .[["snp"]]
    


# create data frame with only prob
genProb <- genProb[,-(1:5)]
              
# function to calculate dosage per SNP (row of genProb data)     
FUN <- function(x){
  mat <- t(matrix(x, nrow = 3))[,-1]
  mat[,2] <- mat[,2]*2
  rowSums2(mat)
}

# apply function to all rows
doseData <- t(apply(genProb, 1, FUN))

# assign dimnames: row = snpids, cols=ids
dimnames(doseData) <- list(snp, iids)

doseData <- doseData %>%
    data.table(keep.rownames = TRUE) %>%
    rename(SNP=rn)

# # transpose data frame
# doseData <- t(doseData) %>%
#     data.frame(IID=iids, .)
