dir="/data/scripts/gwastools_impute";
output_dir="/data/output";
for m in `seq 1 3`;
do
	for j in 100 1000 5000;
	do
		for k in 1000 10000 100000;
		do
			file="${dir}/gwastools_n${j}_p${k}_rep${m}.slurm";
			echo "generating SLURM scripts for gwastools n${j}_p${k}_rep${m}";

if [ $k == 1000 ]
then 
	mem=24000;
	walltime=`expr 12:00:00`;
elif [ $k == 10000 ] 
then
	mem=24000;
	walltime=`expr 20:00:00`;
elif [ $k == 100000 ]
then
	mem=24000;
	walltime=`expr 24:00:00`;
fi 

cat <<EOM > ${file}
#!/bin/bash
#SBATCH --time=${walltime}
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=${mem}
#SBATCH --mail-user=rizvi.33@osu.edu
#SBATCH --mail-type=FAIL
#SBATCH --partition=general-compute
#SBATCH --job-name=gwastools_n${j}_p${k}_rep${m}
#SBATCH --output=${output_dir}/gwastools/results/log/n${j}_p${k}_rep${m}_%j.out
#SBATCH --error=${output_dir}/gwastools/results/log/n${j}_p${k}_rep${m}_%j.err
#Get date and time
tstart=\$(date +%s)
echo "###### start time:"\`date\`
DIRECTORY=/data
SCRIPT=/data/scripts
############################
module load R
R --file=\$SCRIPT/gwastools_survival.R -q --args \\
	chunk.impute \$DIRECTORY/input/impute/genotype/n${j}_p${k}_chr18.impute \\
	chunk.sample \$DIRECTORY/input/impute/gt_samples/n${j}.sample_gt \\
	chr 18 \\
	gds.output \$DIRECTORY/input/impute/gt_gdsfiles/n${j}_p${k}_rep${m}_chr18 \\
	gdsfile \$DIRECTORY/input/impute/gt_gdsfiles/n${j}_p${k}_rep${m}_chr18.gds \\
	scanfile \$DIRECTORY/input/impute/gt_gdsfiles/n${j}_p${k}_rep${m}_chr18.scan.rdata \\
	snpfile \$DIRECTORY/input/impute/gt_gdsfiles/n${j}_p${k}_rep${m}_chr18.snp.rdata \\
	snpstart 1 \\
	snpstop ${k} \\
	gwastools.result \$DIRECTORY/output/gwastools/results/n${j}_p${k}_rep${m}.gwastools
##########################
echo "All Done!"
echo "*************************************************"
echo "SLURM_JOB_ID"=\$SLURM_JOB_ID
echo "SLURM_JOB_NODELIST"=\$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=\$SLURM_NNODES
echo "SLURM_NTASKS"=\$SLURM_NTASKS
echo "SLURMTMPDIR"=\$SLURMTMPDIR
echo "working directory"=\$SLURM_SUBMIT_DIR
echo "*************************************************"
tend=\$(date +%s)
echo "###### end time: "\`date\`
DIFF=\$(( \$tend - \$tstart ))
echo "It took \$DIFF seconds"
EOM

echo -e "\tsub file: ${file}\n" ;
sbatch ${file} --constraint=CPU-L5520 --exclusive;
		done
	done
done
