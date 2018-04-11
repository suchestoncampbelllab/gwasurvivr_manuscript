#!/bin/bash
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=4000
#SBATCH --mail-user=rizvi.33@osu.edu
#SBATCH --mail-type=END
#SBATCH --partition=general-compute
#SBATCH --job-name=gwastools_impute_n5000_p1000_rep3
#SBATCH --output=/projects/rpci/lsuchest/abbasriz/survivr_benchmark/output/gwastools/gwastools_rep3/log/n5000_p1000_slurm_%j.out
#SBATCH --error=/projects/rpci/lsuchest/abbasriz/survivr_benchmark/output/gwastools/gwastools_rep3/log/n5000_p1000_slurm_%j.err

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

DIRECTORY=/projects/rpci/lsuchest/abbasriz/survivr_benchmark
SCRIPT=/projects/rpci/lsuchest/abbasriz/survivr_benchmark/scripts

module load R


R --file=$SCRIPT/gwastools_survival.R -q --args \
	chunk.impute $DIRECTORY/input/impute/genotype/n5000.snp1000.chr1.impute \
	chunk.sample $DIRECTORY/input/impute/gt_samples/n5000_chr1.impute.sample_gt \
	chr 1 \
	gds.output $DIRECTORY/input/impute/gt_gdsfiles/n5000_p1000_chr1\
	gdsfile $DIRECTORY/input/impute/gt_gdsfiles/n5000_p1000_chr1.gds \
	scanfile $DIRECTORY/input/impute/gt_gdsfiles/n5000_p1000_chr1.scan.rdata \
	snpfile $DIRECTORY/input/impute/gt_gdsfiles/n5000_p1000_chr1.snp.rdata \
	snpstart 1 \
	snpstop 1000 \
	gwastools.result $DIRECTORY/output/gwastools/gwastools_rep3/n5000_p1000.impute.gwastools

#######

echo "All Done!"

tend=$(date +%s)
echo "###### end time: "`date`

DIFF=$(( $tend - $tstart ))
echo "It took $DIFF seconds"



exit

