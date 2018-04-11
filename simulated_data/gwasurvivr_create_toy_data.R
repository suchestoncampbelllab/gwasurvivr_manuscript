library(gwasurvivr)
library(VariantAnnotation)
library(tidyverse)
library(data.table)

# creating toy data

vcf.file <- "~/Google Drive/OSU_PHD/sanger_imputed/hrc/14.pbwt_reference_impute.vcf.gz"
chunk.size <- 10000
vcf <- VcfFile(vcf.file, yieldSize=chunk.size)
data <- readVcf(vcf)
data.info <- data[info(data)$INFO>0.1]
data.pts <- data.info[,1:500]
writeVcf(data.pts, filename="~/GoogleDrive/OSU_PHD/sanger_imputed/hrc/chr.pbwt_reference_impute.vcf.gz", index=TRUE )

vcf.file <- "~/GoogleDrive/OSU_PHD/sanger_imputed/hrc/chr.pbwt_reference_impute.vcf.bgz"
vcf.new <- VcfFile(vcf.file)
data.new <- readVcf(vcf.new)


# new data
# vcf.file <- system.file(package="gwasurvivr", "extdata", "sanger.pbwt_reference_impute.vcf.gz")
# vcf <- VcfFile(vcf.file)
# data <- readVcf(vcf)

gp <- geno(data.new)$GP

x <- matrix(nrow=7255, ncol=1500)
for(i in 1:nrow(data.new)){
        x[i,] <- unlist(gp[i,])
        dimnames(x) <- list(rownames(data.new), paste0(rep(paste0("SAMP", 1:500),each=3), c("_gp00", "_gp01", "_gp11")))
}

imp <- data.frame(cbind(
        snpid=info(data.new)$TYPED,
        rsid=rownames(data.new),
        pos=start(data.new),
        ref=as.character(ref(data.new)),
        alt=as.character(unlist(alt(data.new))),
        x), stringsAsFactors = FALSE)

imp <- imp %>%
        mutate(snpid=case_when(snpid==TRUE~rsid,
                               snpid==FALSE~"---"))


imp[1:5,1:9]

write.table(imp, '~/GoogleDrive/OSU_PHD/gwasurvivr/inst/extdata/impute_example.impute2', sep=" ", col.names = FALSE, row.names=FALSE, quote=FALSE)

ID_1 <- c(0:500)
ID_2 <- c(0, paste0("SAMP", 1:500))
missing <- rep(-9, 501)
sex <- rep(2, 501)

samp <- data.frame(cbind(ID_1,
      ID_2,
      missing,
      sex))

head(samp)
write.table(samp, file="~/GoogleDrive/OSU_PHD/gwasurvivr/inst/extdata/impute_example.impute2_sample", sep=" ", col.names=TRUE, row.names=FALSE, quote=FALSE)

set.seed(3456)
sim_dead <- data.frame(event= 1,
                       time=abs(round(rnorm(2000, 4, sd=2.2), 2)),
                       age=round(rnorm(2000, 60, sd=4), 2),
                       bmiOVWT=sample(c(0,1), size = 2000, replace = T, prob = c(0.3, 0.7)),
                       sex=sample(c("male","female"), size = 2000, replace = T, prob = c(0.6, 0.40)),
                       group=sample(c("control", "experimental"), size=2000, replace=T, prob=c(0.5, 0.5))
)

sim_alive <- data.frame(event= 0,
                        time=abs(sample(c(4.3, 6.7, 8.8, 12), size = 3000, replace = T, prob = c(0.05, 0.05, 0.05, 0.85))),
                        age=round(rnorm(3000, 40, sd=4), 2),
                        bmiOVWT=sample(c(0,1), size = 3000, replace = T, prob = c(0.9, 0.1)),
                        sex=sample(c("male","female"), size = 3000, replace = T, prob = c(0.6, 0.40)),
                        group=sample(c("control", "experimental"), size=3000, replace=T, prob=c(0.5, 0.5))
)

bind_rows(sim_dead, sim_alive) %>% 
        sample_n(500) %>%
        mutate(ID_1=1:500,
               ID_2=paste0("SAMP", 1:500)) %>% 
        select(ID_1, ID_2, event:group) -> sim_pheno



write.table(sim_pheno, 
            "~/GoogleDrive/OSU_PHD/gwasurvivr/inst/extdata/simulated_pheno.txt",
            sep = " ",
            row.names = F,
            quote = F)

# cohort <- 1
# info.filter <- 0.7
# maf.filter <- 0.005
# chunk.size <- 10000
# verbose <- TRUE
# donor <- "donor"
# time.to.event <- "intxsurv_1Y"
# event <- "disease_death_1Y"
# covariates <- c("DiseaseStatusAdvanced", "age", "MDSdummy")
# pheno.file <- read.table("/projects/rpci/lsuchest/lsuchest/DBMT_PhenoData/DBMT_PhenoData_EA_long_lessVar20171107.txt", sep="\t", header=TRUE, stringsAsFactors = FALSE)
# pheno.file <- pheno.file %>%
#         filter_(lazyeval::interp(quote(x == y), x=as.name("sample_type"), y=donor),
#                 lazyeval::interp(quote(x == y), x=as.name("cohort"), y=cohort),
#                 lazyeval::interp(quote(x != y), x=as.name("ALLdummy"), y=1)) %>%
#         mutate(DiseaseStatusAdvanced=case_when(distatD=="advanced"~1,
#                                                distatD=="early"~0)) 
# typed.fam <- fread("/projects/rpci/lsuchest/lsuchest/Rserve/BMT/genetic_data/PLINK2VCF/BMT_TOP_ALL.37.cleaned.subsetEA.fam")
# typed.fam <- typed.fam %>%
#         mutate(V7=paste0("SAMP", 1:nrow(typed.fam)))
# pheno.file$IID <- typed.fam$V7[match(pheno.file$IID, typed.fam$V2)]
# sample.ids <- pheno.file$IID


# 
# if(verbose) message("Analysis started on ", format(Sys.time(), "%Y-%m-%d"), " at ", format(Sys.time(), "%H:%M:%S"))
# 
# # subset phenotype file for sample ids
# pheno.file <- pheno.file[match(sample.ids, pheno.file[[1]]), ]
# if(verbose) message("Analysis running for ", nrow(pheno.file), " samples.")
# 
# # covariates are defined in pheno.file
# ok.covs <- colnames(pheno.file)[colnames(pheno.file) %in% covariates]
# if(verbose) message("Covariates included in the models are: ", paste(ok.covs, collapse=", "))
# if(verbose) message("If your covariates of interest are not included in the model\nplease stop the analysis and make sure user defined covariates\nmatch the column names in the pheno.file")



vcf <- VcfFile(vcf.file, yieldSize=chunk.size)
open(vcf)
# get genotype probabilities by chunks
# apply the survival function and save output
pheno.file <- pheno.file[,-1]
pheno.file <- as.matrix(pheno.file[,c(time.to.event, event, covariates)])
params <- coxParam(pheno.file, time.to.event, event, covariates, sample.ids)

N <- nrow(pheno.file)
NEVENTS <- sum(pheno.file[,event]==1)


data <- readVcf(vcf, param=ScanVcfParam(geno="DS"))
# read dosage data from collapsed vcf, subset for defined ids
genotype <- geno(data)$DS[, match(sample.ids, colnames(data)) , drop=F]


# grab info, REFPAN_AF, TYPED/IMPUTED, INFO
# calculates sample MAF
snp.ids <- rownames(data)
snp.ranges <- data.frame(SummarizedExperiment::rowRanges(data))
snp.ranges <- snp.ranges[,c("seqnames", "start", "REF", "ALT")]
snp.meta <- data.frame(info(data))[,c("AF", "MAF", "R2")]
samp.maf <- round(matrixStats::rowMeans2(genotype)*0.5, 4)

snp.info <- cbind(RSID=snp.ids,
                  snp.ranges,
                  snp.meta,
                  SAMP_MAF=samp.maf)

idx <- sort(unique(c(which(snp.info$R2 > info.filter &
                                   snp.info$MAF > maf.filter &
                                   snp.info$MAF < (1-maf.filter))
                     )
                   )
            )

snp.maf.filt <- snp.info[idx,]



snp.maf.filt$ALT <- sapply(snp.maf.filt$ALT, as.character)
snp.maf.filt$RefPanelAF <- sapply(snp.maf.filt$RefPanelAF, as.numeric)
colnames(snp.maf.filt) <- c("RSID", "CHR", "POS", "REF", "ALT", "AF", "MAF", "INFO", "SAMP_MAF")
snp.maf.filt <- snp.maf.filt[,c("RSID", "CHR", "POS", "REF", "ALT", "AF", "MAF", "SAMP_MAF", "INFO")]

