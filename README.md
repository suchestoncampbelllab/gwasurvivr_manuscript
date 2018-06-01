
Introduction
============

Code and data provided here are for [gwasurvivr: an R package for genome wide survival analysis](https://www.biorxiv.org/content/early/2018/05/18/326033) manuscript.

To reproduce the results please clone the repo.

Abstract
========

To address the limited software options for performing survival analyses with millions of SNPs, we developed gwasurvivr, an R/Bioconductor package with a simple interface for conducting fast genome wide survival analyses using VCF (outputted from Michigan or Sanger imputation servers) and IMPUTE2 files. We benchmarked gwasurvivr with other GWAS software capable of conducting genome wide survival analysis (genipe, SurvivalGWAS\_SV, and GWASTools) and demonstrate improved scalability including shorter runtimes for large sample sizes and larger number of SNPs.

<!-- # Repo Structure -->
<!-- - `code` : Scripts used for software comparisons and to generate figures used in the manuscript.       -->
<!--     - `code/create_*_scripts.sh`: Scripts used to generate shell scripts that submit jobs on a computing cluster for each software. -->
<!--     - `code/diagnosticFigures.R`: R code to generate the diagnostic figures -->
<!--     - `code/gwastools_survival.R`: R function to benchmark `GWASTools` -->
<!--     - `code/run_gwasurvivr.R`: R function to benchmark `gwasurvivr` -->
<!--     - `code/timePlots`: R code to generate time comparison plots. -->
<!-- - `data` : Simulated data used for software benchmarking and supplemental material.      -->
<!--     - `data/input/impute`: Example data sets -->
<!--         - `data/input/impute/covariates`: Time event and covariate example data -->
<!--         - `data/input/impute/genotype`: Genotype data used for comparisons, should be unzipped before analysis. The file name `n#_p#_chr18.impute.gz` gives the number of samples (`n`) and SNPs (`p`). -->
<!--         - `data/input/impute/gt_samples`: GT sample files -->
<!--         - `data/input/impute/sample`: Example sample files listing the sample IDs -->
<!--         - `data/input/impute/sample_ids`: Example sample ID lists, used to subset datasets. -->
<!--         - `data/input/impute/sv_samples`: Example sample files as required by `SurvivalGWAS_SV`. -->
<!--     - `data/supplemental_data`: Genotype data used to compare survival with modified version implemented in gwasurvivr -->
<!-- - `figures`: Supplemental figures.       -->
Repo Structure
==============

**`code` **: Scripts used for software comparisons and to generate figures used in the manuscript.

-   `code/create_*_scripts.sh`: Scripts used to generate shell scripts that submit jobs on a computing cluster for each software.
-   `code/diagnosticFigures.R`: R code to generate the diagnostic figures
-   `code/gwastools_survival.R`: R function to benchmark `GWASTools`
-   `code/run_gwasurvivr.R`: R function to benchmark `gwasurvivr`
-   `code/timePlots`: R code to generate time comparison plots.

**`data`** : Simulated data used for software benchmarking and supplemental material.
- `data/input/impute`: Example data sets

    - `data/input/impute/covariates`: Time event and covariate example data
    - `data/input/impute/genotype`: Genotype data used for comparisons, should be unzipped before analysis. The file name `n#_p#_chr18.impute.gz` gives the number of samples (`n`) and SNPs (`p`).
    - `data/input/impute/gt_samples`: GT sample files
    - `data/input/impute/sample`: Example sample files listing the sample IDs
    - `data/input/impute/sample_ids`: Example sample ID lists, used to subset datasets.
    - `data/input/impute/sv_samples`: Example sample files as required by `SurvivalGWAS_SV`.

-   `data/supplemental_data`: Genotype data used to compare survival with modified version implemented in gwasurvivr

**`figures`**: Supplemental figures.
