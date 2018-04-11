#!/bin/bash
#SBATCH --time=16:00:00
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=16000
#SBATCH --mail-user=rizvi.33@osu.edu
#SBATCH --mail-type=END
#SBATCH --partition=general-compute
#SBATCH --job-name=gwasurvivr_impute_n1000_p10000_rep2
#SBATCH --output=/projects/rpci/lsuchest/abbasriz/survivr_benchmark/output/survivr/gwasurvivr_rep2/log/n1000_p10000_slurm_%j.out
#SBATCH --error=/projects/rpci/lsuchest/abbasriz/survivr_benchmark/output/survivr/gwasurvivr_rep2/log/n1000_p10000_slurm_%j.err

#Get date and time
tstart=$(date +%s)
echo "###### start time:"$tstart

DIRECTORY=/projects/rpci/lsuchest/abbasriz/survivr_benchmark
SCRIPT=/projects/rpci/lsuchest/abbasriz/survivr_benchmark/scripts

########

module load R

R --file=$SCRIPT/gwasurvivr_survival.R -q --args \
	impute.chunk $DIRECTORY/input/impute/genotype/n1000.snp10000.chr1.impute \
	sample.chunk $DIRECTORY/input/impute/sample/n1000.chr1.impute_sample \
	covfile $DIRECTORY/input/impute/covariates/simulated_pheno.txt \
	sample.ids $DIRECTORY/input/impute/sample_ids/sample_ids_n1000.txt \
	outfile $DIRECTORY/output/survivr/gwasurvivr_rep2/n1000_p10000.impute.survivr

########

echo "All Done!"

echo "SLURM_JOB_ID"=$SLURM_JOB_ID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=$SLURM_NNODES
echo "SLURMTMPDIR"=$SLURMTMPDIR
echo "working directory"=$SLURM_SUBMIT_DIR

echo "*************************************************"

NPROCs=`srun --nodes=${SLURM_NNODES} bash -c 'hostname' | wc -l`
echo NPROCS=$NRPOCS

tend=$(date +%s)
echo "###### end time: $tend"

DIFF=$(( $tend - $tstart ))
echo "It took $DIFF seconds"

exit
