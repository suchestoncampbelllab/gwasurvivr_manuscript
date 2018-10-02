#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --tasks-per-node=8
#SBATCH --mem=24000
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=user.name@university.edu
#SBATCH --mail-type=FAIL
#SBATCH --partition=general-compute --qos=general-compute
#SBATCH --job-name=gwasurvivr_bigNs
#SBATCH --output=/projects/rpci/lsuchest/ezgi/gwasurvivr_sims/run_bigNs/log/25K_%j.out
#SBATCH --error=/projects/rpci/lsuchest/ezgi/gwasurvivr_sims/run_bigNs/log/25K_%j.err

#Get date and time
tstart=$(date +%s)
echo "###### start time:"$tstart

DIRECTORY=/gwasurvivr_manuscript/largeN_experiment/

########


module load R

R --file=$DIRECTORY/code/run_bigNs.R -q --args \
	impute.file $DIRECTORY/genetic_data/N_25K.gen.gz \
	sample.file $DIRECTORY/sample_files/N_25K.sample \
	covariate.file $DIRECTORY/pheno_files/N25K_pheno.txt \
	out.file $DIRECTORY/result_files/N25K 


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

