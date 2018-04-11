#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=8000
#SBATCH --mail-user=karaesmen.1@osu.edu
#SBATCH --mail-type=END
#SBATCH --partition=general-compute
#SBATCH --job-name=genipe_n1000_p1000_nothresh
#SBATCH --output=/projects/rpci/lsuchest/abbasriz/survivr_benchmark/output/genipe/log/genipe_n1000_p1000_%j.out
#SBATCH --error=/projects/rpci/lsuchest/abbasriz/survivr_benchmark/output/genipe/log/genipe_n1000_p1000_%j.err

#Get date and time
tstart=$(date +%s)
echo "###### start time:"`date`

echo "SLURM_JOB_ID"=$SLURM_JOB_ID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=$SLURM_NNODES
echo "SLURMTMPDIR"=$SLURMTMPDIR
echo "working directory"=$SLURM_SUBMIT_DIR

echo "*************************************************"

NPROCs=`srun --nodes=${SLURM_NNODES} bash -c 'hostname' | wc -l`
echo NPROCS=$NRPOCS


module load python/anaconda2-4.2.0
module load genipe/1.3.1
source activate py34-genipe


DIRECTORY=/projects/rpci/lsuchest/abbasriz/survivr_benchmark

#####################

imputed-stats cox \
    --impute2 $DIRECTORY/input/impute/genotype/n1000_snps1k_chr21.25000005-25500000.impute \
    --sample $DIRECTORY/input/impute/sample/n1000_chr21.25000005-25500000.impute.sample \
    --pheno $DIRECTORY/input/impute/covariates/n1000_cov.phenotype \
    --out $DIRECTORY/output/genipe/n1000_p1000_nothresh.impute.genipe \
    --nb-process 8 \
    --nb-lines 6000 \
    --prob 0 \
    --maf 0 \
    --gender-column sex \
    --covar age,bmiOVWT,sex  \
    --sample-column ID_2 \
    --time-to-event time \
    --event event


#####################

echo "All Done!"

tend=$(date +%s)
echo "###### end time: "`date`

DIFF=$(( $tend - $tstart ))
echo "It took $DIFF seconds"


exit
