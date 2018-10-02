#!/bin/bash
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=24000
#SBATCH --mail-user=user.name@university.edu
#SBATCH --mail-type=FAIL
#SBATCH --partition=general-compute --qos=general-compute
#SBATCH --job-name=genipe_n5000_p100000_cov12
#SBATCH --output=/gwasurvivr_manuscript/diff_cov_benchmarks/results/genipe/log/genipe_n5000_p100000_cov12_%j.out
#SBATCH --error=/gwasurvivr_manuscript/diff_cov_benchmarks/results/genipe/log/genipe_n5000_p100000_cov12_%j.err

#Get date and time
tstart=$(date +%s)
echo "###### start time:"`date`

#####################

module load python/anaconda2-4.2.0
module load genipe/1.3.1
source activate py34-genipe

export OPENBLAS_NUM_THREADS=1
export MKL_NUM_THREADS=1

DIRECTORY=/gwasurvivr_manuscript/benchmark_experiments/data

imputed-stats cox \
    --impute2 $DIRECTORY/input/impute/genotype/n5000_p100000_chr18.impute \
    --sample $DIRECTORY/input/impute/sample/n5000.impute_sample \
    --pheno $DIRECTORY/input/impute/covariates/n5000_cov_pcs.phenotype \
    --out /gwasurvivr_manuscript/benchmark_experiments/genipe/results/n5000_p100000_cov12.genipe \
    --nb-process $SLURM_NTASKS \
    --nb-lines 100000 \
    --prob 0 \
    --maf 0 \
    --gender-column sex \
    --covar age,DrugTxYes,sex,pc1,pc2,pc3,pc4,pc5,pc6,pc7,pc8,pc9 \
    --sample-column ID_2 \
    --time-to-event time \
    --event event

#####################

echo "All Done!"

echo "*************************************************"

echo "SLURM_JOB_ID"=$SLURM_JOB_ID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=$SLURM_NNODES
echo "SLURM_NTASKS"=$SLURM_NTASKS
echo "SLURMTMPDIR"=$SLURMTMPDIR
echo "working directory"=$SLURM_SUBMIT_DIR

echo "*************************************************"

tend=$(date +%s)
echo "###### end time: "`date`

DIFF=$(( $tend - $tstart ))
echo "It took $DIFF seconds"

exit
