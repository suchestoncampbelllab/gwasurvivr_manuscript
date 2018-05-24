library(GWASTools)
library(batch)

parseCommandArgs(evaluate=TRUE)

GT_surv <- function(chunk.impute, chunk.sample, chr, gds.output, gdsfile, scanfile, snpfile, snpstart, snpstop, gwastools.result){
        convertImputeGds <- function(chunk.impute, chunk.sample, chr, gds.output){
                gds <- paste0(gds.output, ".gds")
                snp <- paste0(gds.output, ".snp.rdata")
                scan <- paste0(gds.output, ".scan.rdata")
                imputedDosageFile(input.files=c(chunk.impute, chunk.sample),
                                  filename=gds,
                                  chromosome=as.numeric(chr),
                                  input.type="IMPUTE2",
                                  input.dosage=FALSE,
                                  file.type="gds",
                                  snp.annot.filename = snp,
                                  scan.annot.filename = scan)
                }        
        
        convertImputeGds(chunk.impute, chunk.sample, chr, gds.output)
        
        
        
        gds <- GdsGenotypeReader(gdsfile, genotypeDim="scan,snp")
        snpAnnot <- getobj(snpfile)
        # read scan
        scanAnnot <- getobj(scanfile)
        # put into GenotypeData coding 
        genoData <- GenotypeData(gds,
                                 snpAnnot=snpAnnot,
                                 scanAnnot=scanAnnot)
        
        res <- assocCoxPH(genoData,
                          event="event",
                          time.to.event="time",
                          covar=c("sex.sample", "age", "DrugTxYes"),
                          snpStart=snpstart, 
                          snpEnd=snpstop)
        
        res$snpID <- genoData@snpAnnot@data$rsID[res$snpID]
        
        write.table(na.omit(res),
                    file = gwastools.result,
                    sep=" ",
                    quote=FALSE,
                    row.names=FALSE,
                    col.names=TRUE)  
}

GT_surv(chunk.impute, chunk.sample, as.numeric(chr), gds.output, gdsfile, scanfile, snpfile, snpstart, snpstop, gwastools.result)

