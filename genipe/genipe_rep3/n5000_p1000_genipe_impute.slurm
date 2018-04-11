#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=16000
#SBATCH --mail-user=rizvi.33@osu.edu
#SBATCH --mail-type=END
#SBATCH --partition=general-compute
#SBATCH --job-name=genipe_n5000_p1000_rep3
#SBATCH --output=/projects/rpci/lsuchest/abbasriz/survivr_benchmark/output/genipe/genipe_rep3/log/genipe_n5000_p1000_%j.out
#SBATCH --error=/projects/rpci/lsuchest/abbasriz/survivr_benchmark/output/genipe/genipe_rep3/log/genipe_n5000_p1000_%j.err

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
    --impute2 $DIRECTORY/input/impute/genotype/n5000.snp1000.chr1.impute \
    --sample $DIRECTORY/input/impute/sample/n5000.chr1.impute_sample \
    --pheno $DIRECTORY/input/impute/covariates/n5000_cov.phenotype \
    --out $DIRECTORY/output/genipe/genipe_rep3/n5000_p1000.impute.genipe \
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
