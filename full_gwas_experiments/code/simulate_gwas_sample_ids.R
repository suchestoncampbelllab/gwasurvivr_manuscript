## generate sample ids for full gwas
set.seed(333)



ids_3000 <- c(
    paste0("CASE", sample(1:3000, 1000)),
    paste0("CONT", sample(1:6000, 2000))
)

write.table(ids_3000, "/gwasurvivr_manuscript/full_gwas_experiments/data/sample_ids/n3000_sample_ids.txt", sep="\t", quote=FALSE, row.names=FALSE, col.names=FALSE)

ids_6000 <- c(
    paste0("CASE", sample(1:3000, 2000)),
    paste0("CONT", sample(1:6000, 4000))
)

write.table(ids_6000, "/gwasurvivr_manuscript/full_gwas_experiments/data/sample_ids/n6000_sample_ids.txt", sep="\t", quote=FALSE, row.names=FALSE, col.names=FALSE)


ids_9000 <- c(
    paste0("CASE", sample(1:3000, 3000)),
    paste0("CONT", sample(1:6000, 6000))
)

write.table(ids_9000, "/gwasurvivr_manuscript/full_gwas_experiments/data/sample_ids/n9000_sample_ids.txt", sep="\t", quote=FALSE, row.names=FALSE, col.names=FALSE)

