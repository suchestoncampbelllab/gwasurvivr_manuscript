#!/bin/bash
#SBATCH --time=03:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=24000
#SBATCH --mail-user=user.name@university.edu
#SBATCH --mail-type=FAIL
#SBATCH --partition=general-compute --qos=general-compute
#SBATCH --job-name=gwasurvivr_n5000_p100000_cov4
#SBATCH --output=/gwasurvivr_mnauscript/diff_cov_experiments/results/gwasurvivr/log/gwasurvivr_n5000_p100000_cov4_%j.out
#SBATCH --error=/gwasurvivr_mnauscript/diff_cov_experiments/results/gwasurvivr/log/gwasurvivr_n5000_p100000_cov4_%j.err

#Get date and time
tstart=$(date +%s)
echo "###### start time:"$tstart

DIRECTORY=/gwasurvivr_manuscript/benchmark_experiments/data
SCRIPT=/gwasurvivr_mnauscript/diff_cov_experiments/code

########

module load R

R --file=$SCRIPT/run_gwasurvivr_covs.R -q --args \
	impute.chunk $DIRECTORY/input/impute/genotype/n5000_p100000_chr18.impute \
	sample.chunk $DIRECTORY/input/impute/sample/n5000.impute_sample \
	covariate.file $DIRECTORY/input/impute/covariates/n5000_cov_pcs.phenotype \
	sample.ids $DIRECTORY/input/impute/sample_ids/sample_ids_n5000.txt \
	output /gwasurvivr_mnauscript/diff_cov_experiments/results/gwasurvivr/n5000_p100000_cov4.gwasurvivr \
	chunk.size 10000 \
	ncores $SLURM_NTASKS \
	covariate cov4

########

echo "All Done!"

echo "*************************************************"
echo "SLURM_JOB_ID"=$SLURM_JOB_ID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=$SLURM_NNODES
echo "SLURMTMPDIR"=$SLURMTMPDIR
echo "working directory"=$SLURM_SUBMIT_DIR
echo "*************************************************"

tend=$(date +%s)
echo "###### end time: "`date`

DIFF=$(( $tend - $tstart ))
echo "It took $DIFF seconds"

exit
