#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=32000
#SBATCH --mail-user=rizvi.33@osu.edu
#SBATCH --mail-type=END
#SBATCH --partition=general-compute
#SBATCH --job-name=n1000_p1000_sv_impute_rep2
#SBATCH --output=/projects/rpci/lsuchest/abbasriz/survivr_benchmark/output/sv/log/n1000_p1000_sv_impute_rep2_%A_%a.out
#SBATCH --error=/projects/rpci/lsuchest/abbasriz/survivr_benchmark/output/sv/log/n1000_p1000_sv_impute_rep2_%A_%a.err
#SBATCH --array=1-10


#Get date and time
tstart=$(date +%s)
echo "###### start time:"`date`

DIRECTORY=/projects/rpci/lsuchest/abbasriz/survivr_benchmark/
str1=0
str=1000
no_of_jobs=10

inc=`expr \( $str - $str1 \) \/ $no_of_jobs` #Increment

# SGE_TASK_ID takes values 1:no_of_jobs
nstart=`expr \( $SLURM_ARRAY_TASK_ID - 1 \) \* $inc`

nstop=`expr $nstart + $inc - 1`

############################

mono /util/academic/survivalGWAS/survivalGWAS_SV-v1.3.1/survivalgwas-sv.exe \
	-gf=$DIRECTORY/input/impute/genotype/n1000.snp1000.chr1.impute \
	-sf=$DIRECTORY/input/impute/sv_samples/n1000_chr1.impute.sample_sv \
	-threads=1 \
	-t=time \
	-c=event \
	-cov=sex,age,bmiOVWT \
	-chr=1 \
	-lstart=$nstart \
	-lstop=$nstop \
	-method="cox" \
	-p="onlysnp" \
	-o=$DIRECTORY/output/sv/sv_rep2/n1000_p1000/n1000_p1000_${SLURM_ARRAY_TASK_ID}.impute.sv

############################

echo "All Done!"

echo "*************************************************"
echo "SLURM_JOB_ID"=$SLURM_JOB_ID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=$SLURM_NNODES
echo "SLURMTMPDIR"=$SLURMTMPDIR
echo "working directory"=$SLURM_SUBMIT_DIR
echo "*************************************************"


NPROCs=`srun --nodes=${SLURM_NNODES} bash -c 'hostname' | wc -l`
echo NPROCS=$NRPOCS

tend=$(date +%s)
echo "###### end time: "`date`

DIFF=$(( $tend - $tstart ))
echo "It took $DIFF seconds"

exit
