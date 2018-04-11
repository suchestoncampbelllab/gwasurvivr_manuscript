#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=32000
#SBATCH --mail-user=rizvi.33@osu.edu
#SBATCH --mail-type=END
#SBATCH --partition=general-compute
#SBATCH --job-name=gwastools_impute_n100_p100000_rep2
#SBATCH --output=/projects/rpci/lsuchest/abbasriz/survivr_benchmark/output/gwastools/gwastools_rep2/log/n100_p100000_slurm_%j.out
#SBATCH --error=/projects/rpci/lsuchest/abbasriz/survivr_benchmark/output/gwastools/gwastools_rep2/log/n100_p100000_slurm_%j.err

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
	chunk.impute $DIRECTORY/input/impute/genotype/n100.snp100000.chr1.impute \
	chunk.sample $DIRECTORY/input/impute/gt_samples/n100_chr1.impute.sample_gt \
	chr 1 \
	gds.output $DIRECTORY/input/impute/gt_gdsfiles/n100_p100000_chr1\
	gdsfile $DIRECTORY/input/impute/gt_gdsfiles/n100_p100000_chr1.gds \
	scanfile $DIRECTORY/input/impute/gt_gdsfiles/n100_p100000_chr1.scan.rdata \
	snpfile $DIRECTORY/input/impute/gt_gdsfiles/n100_p100000_chr1.snp.rdata \
	snpstart 1 \
	snpstop 100000 \
	gwastools.result $DIRECTORY/output/gwastools/gwastools_rep2/n100_p100000.impute.gwastools

#######

echo "All Done!"

tend=$(date +%s)
echo "###### end time: "`date`

DIFF=$(( $tend - $tstart ))
echo "It took $DIFF seconds"



exit
