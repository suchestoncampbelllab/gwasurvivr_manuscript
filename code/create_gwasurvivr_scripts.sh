dir="/data/scripts/gwasurvivr_impute";
output_dir="output";
for m in `seq 1 3`;
do
	for j in 100 1000 5000;
	do
		for k in 1000 10000 100000;
		do
			file="${dir}/gwasurvivr_n${j}_p${k}_rep${m}.slurm";
			echo "generating SLURM scripts for gwasurvivr n${j}_p${k}_rep${m}";

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
#SBATCH --mail-user=user.name@university.edu
#SBATCH --mail-type=FAIL
#SBATCH --partition=general-compute
#SBATCH --job-name=gwasurvivr_n${j}_p${k}_rep${m}
#SBATCH --output=${output_dir}/gwasurvivr/results/log/n${j}_p${k}_rep${m}_%j.out
#SBATCH --error=${output_dir}/gwasurvivr/results/log/n${j}_p${k}_rep${m}_%j.err

#Get date and time
tstart=\$(date +%s)
echo "###### start time:"\$tstart

DIRECTORY=/data
SCRIPT=/code

########

module load R

R --file=\$SCRIPT/run_gwasurvivr.R -q --args \\
	impute.chunk \$DIRECTORY/input/impute/genotype/n${j}_p${k}_chr18.impute \\
	sample.chunk \$DIRECTORY/input/impute/sample/n${j}.impute_sample \\
	covariate.file \$DIRECTORY/input/impute/covariates/simulated_pheno.txt \\
	sample.ids \$DIRECTORY/input/impute/sample_ids/sample_ids_n${j}.txt \\
	output \$DIRECTORY/output/gwasurvivr/results/n${j}_p${k}_rep${m}.gwasurvivr \\
	chunk.size 10000 \\
	ncores \$SLURM_NTASKS

########

echo "All Done!"

echo "*************************************************"
echo "SLURM_JOB_ID"=\$SLURM_JOB_ID
echo "SLURM_JOB_NODELIST"=\$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=\$SLURM_NNODES
echo "SLURMTMPDIR"=\$SLURMTMPDIR
echo "working directory"=\$SLURM_SUBMIT_DIR
echo "*************************************************"

tend=\$(date +%s)
echo "###### end time: "\`date\`

DIFF=\$(( \$tend - \$tstart ))
echo "It took \$DIFF seconds"

exit

EOM

echo -e "\tsub file: ${file}\n" ;
sbatch ${file} --constraint=CPU-L5520 --exclusive;
					 
		done
	done
done
