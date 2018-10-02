## simulating principal components
library(tidyverse)

### genipe 

cov <- read_delim("/gwasurvivr_mnauscript/benchmark_experiments/data/impute/input/covariates/n5000.phenotype", delim=" ")



pc1 <- rnorm(1:5000, mean=0, sd=5)
pc2 <- rnorm(1:5000, mean=0, sd=3)
pc3 <- rnorm(1:5000, mean=0, sd=0.5)
pc4 <- rnorm(1:5000, mean=0, sd=0.4)
pc5 <- rnorm(1:5000, mean=0, sd=0.3)
pc6 <- rnorm(1:5000, mean=0, sd=0.2)
pc7 <- rnorm(1:5000, mean=0, sd=0.1)
pc8 <- rnorm(1:5000, mean=0, sd=0.05)
pc9 <- rnorm(1:5000, mean=0, sd=0.01)

system.time(pcs <- data.frame(pc1=pc1,
                  pc2=pc2,
                  pc3=pc3,
                  pc4=pc4,
                  pc5=pc5,
                  pc6=pc6,
                  pc7=pc7,
                  pc8=pc8,
                  pc9=pc9))


cov2 <- cbind(cov, pcs)

write.table(cov2, file="/gwasurvivr_mnauscript/benchmark_experiments/data/impute/input/covariates/n5000_cov_pcs.phenotype",
            sep="\t", quote=FALSE, row.names=FALSE, col.names=TRUE)



### sv 

sample_sv <- read_delim("/gwasurvivr_mnauscript/benchmark_experiments/data/impute/input/sv_samples/5000.sample_sv", delim=" ")




cov_sv <- cbind(sample_sv, pcs)

write.table(cov_sv,
            file="/gwasurvivr_mnauscript/benchmark_experiments/data/impute/input/sv_samples/n5000.covs.sample_sv",
            sep=" ", quote=FALSE, row.names=FALSE, col.names=TRUE)

## gwastools
gt_sample <- read_delim("/gwasurvivr_mnauscript/benchmark_experiments/data/impute/input/gt_samples/n5000.sample_gt", delim=" ")


cov_gt <- cbind(gt_sample, rbind("C", pcs))

cov_gt <- range(cov_gt$time)x

write.table(cov_gt,
            file="/gwasurvivr_mnauscript/benchmark_experiments/data/impute/input/gt_samples/n5000.covs.sample_gt",
            sep=" ", quote=FALSE, row.names=FALSE, col.names=TRUE)
