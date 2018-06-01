
Introduction
============

Code and data provided here are for gwasurvivr: an R package for genome wide survival analysis manuscript. 

The preprint is available on bioRxiv (https://www.biorxiv.org/content/early/2018/05/18/326033).

The package can be found on Bioconductor: https://www.bioconductor.org/packages/gwasurvivr

The package repository can be found at https://github.com/suchestoncampbelllab/gwasurvivr

To download code and simulated data in order to reproduce the results please clone this repository.

```
git clone https://github.com/suchestoncampbelllab/gwasurvivr_manuscript.git
```

Abstract
========

To address the limited software options for performing survival analyses with millions of SNPs, we developed `gwasurvivr`, an R/Bioconductor package with a simple interface for conducting fast genome wide survival analyses using VCF (outputted from Michigan or Sanger imputation servers) and IMPUTE2 files. We benchmarked gwasurvivr with other GWAS software capable of conducting genome wide survival analysis (`genipe`, `SurvivalGWAS_SV`, and `GWASTools`) and demonstrate improved scalability including shorter runtimes for large sample sizes and larger number of SNPs.

Repo Structure
==============

**`code`**: Scripts used for software comparisons and to generate figures used in the manuscript.

-   `/code/create_*_scripts.sh`: Scripts used to generate shell scripts that submit jobs on a computing cluster for each software.
-   `/code/diagnosticFigures.R`: R code to generate the diagnostic figures
-   `/code/gwastools_survival.R`: R function to benchmark `GWASTools`
-   `/code/run_gwasurvivr.R`: R function to benchmark `gwasurvivr`
-   `/code/timePlots.R`: R code to generate time comparison plots. 
-   `/code/generate_simulated_geno.sh`: Shell script to use HAPGENv2 and make simulated data using 1000G chr18
-   `/code/generate_simulated.pheno.R`: R script on how to generate simulated phenotype data
-   `/code/parse_times_from_results.pl`: perl script to grab times and compute node info from `log` files. this script is usually dropped into the log folder and then run interactively.



**`data`** : Simulated data used for software benchmarking and supplemental material.
- `data/input/impute`: Example data sets

    - `/data/input/impute/covariates`: Time event and covariate example data
    - `/data/input/impute/genotype`: Genotype data used for comparisons, **should be unzipped before analysis**. The file name `n#_p#_chr18.impute.gz` gives the number of samples (`n`) and SNPs (`p`).
    - `/data/input/impute/gt_samples`: GWASTools sample files
    - `/data/input/impute/gt_gdsfiles`: GWASTools GDS files    
    - `/data/input/impute/sample`: Example sample files listing the sample IDs
    - `/data/input/impute/sample_ids`: Example sample ID lists, used to subset datasets.
    - `/data/input/impute/sv_samples`: Example sample files as required by `SurvivalGWAS_SV`.

-   `/data/supplemental_data`: Genotype data used to compare survival with modified version implemented in gwasurvivr

**`figures`**: Main paper and Supplemental figures.

**`hapgen2`**: Directory that has the 1000 Genomes CEU data for chromosome 18 and the simulated results. Please refer to `/code/generate_simulated.geno.sh` for how simulated data was generated. The data is compressed and should be **unzipped** to fully replicate results without generating own data. 
