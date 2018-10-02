#!/bin/bash
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=8000
#SBATCH --mail-user=rizvi.33@osu.edu
#SBATCH --mail-type=FAIL
#SBATCH --partition=general-compute --qos=general-compute
#SBATCH --job-name=sv_n5000_p100000_cov8
#SBATCH --output=/gwasurvivr_mnauscript/diff_cov_experiments/results/sv/log/sv_n5000_p100000_cov8_%A_%a.out
#SBATCH --error=/gwasurvivr_mnauscript/diff_cov_experiments/results/sv/log/sv_n5000_p100000_cov8_%A_%a.err
#SBATCH --array=1-100

#Get date and time
tstart=$(date +%s)
echo "###### start time:"`date`

DIRECTORY=/gwasurvivr_mnauscript/benchmark_experiments/data
str1=0
str=100000
no_of_jobs=100

inc=`expr \( $str - $str1 \) \/ $no_of_jobs` #Increment

#SLURM_ARRAY_TASK_ID takes values 1:no_of_jobs
nstart=`expr \( $SLURM_ARRAY_TASK_ID - 1 \) \* $inc`

nstop=`expr $nstart + $inc - 1`

############################

mono /util/academic/survivalGWAS/SurvivalGWAS_SV_v1.3.2/survivalgwas-sv.exe \
	-gf=$DIRECTORY/input/impute/genotype/n5000_p100000_chr18.impute \
	-sf=$DIRECTORY/input/impute/sv_samples/n5000.covs.sample_sv \
	-threads=$SLURM_NTASKS \
	-t=time \
	-c=event \
	-cov=sex,age,DrugTxYes,pc1,pc2,pc3,pc4,pc5 \
	-chr=18 \
	-lstart=$nstart \
	-lstop=$nstop \
	-method="cox" \
	-p="onlysnp" \
	-o=/gwasurvivr_mnauscript/diff_cov_experiments/results/sv/n5000_p100000_cov8_${SLURM_ARRAY_TASK_ID}.sv

############################

echo "All Done!"

echo "*************************************************"
echo "SLURM_JOB_ID"=$SLURM_JOB_ID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=$SLURM_NNODES
echo "SLURMTMPDIR"=$SLURMTMPDIR
echo "working directory"=$SLURM_SUBMIT_DIR
echo "SLURM_NTASKS"=$SLURM_NTASKS
echo "*************************************************"

tend=$(date +%s)
echo "###### end time: "`date`

DIFF=$(( $tend - $tstart ))
echo "It took $DIFF seconds"

exit