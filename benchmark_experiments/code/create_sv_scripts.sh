dir="/gwasurvivr_manuscript/benchmark_experiments/code/sv_impute";
output_dir="/gwasurvivr_manuscript/benchmark_experiments/results/sv";
for m in `seq 1 3`;
do
	for j in 100 1000 5000;
	do
		for k in 1000 10000 100000;
		do
			file="${dir}/sv_n${j}_p${k}_rep${m}.slurm";
			echo "generating SLURM scripts for SV trials n${j}_p${k}_rep${m}";
			
if [ $k == 1000 ]
then 
	arr=1;
	mem=24000;
	walltime=`expr 24:00:00`;
elif [ $k == 10000 ] 
then
	arr=10;
	mem=24000;
	walltime=`expr 48:00:00`;
elif [ $k == 100000 ]
then
	arr=100;
	mem=24000;
	walltime=`expr 72:00:00`;
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
#SBATCH --job-name=sv_n${j}_p${k}_rep${m}
#SBATCH --output=${output_dir}/sv/sv_rep${m}/log/sv_n${j}_p${k}_rep${m}_%A_%a.out
#SBATCH --error=${output_dir}/sv/sv_rep${m}/log/sv_n${j}_p${k}_rep${m}_%A_%a.err
#SBATCH --array=1-${arr}
#Get date and time
tstart=\$(date +%s)
echo "###### start time:"\`date\`
DIRECTORY=/gwasurvivr_manuscript/benchmark_experiments/data/
str1=0
str=${k}
no_of_jobs=${arr}
inc=\`expr \( \$str - \$str1 \) \/ \$no_of_jobs\` #Increment
#SLURM_ARRAY_TASK_ID takes values 1:no_of_jobs
nstart=\`expr \( \$SLURM_ARRAY_TASK_ID - 1 \) \* \$inc\`
nstop=\`expr \$nstart + \$inc - 1\`
############################
mono /util/academic/survivalGWAS/SurvivalGWAS_SV_v1.3.2/survivalgwas-sv.exe \\
	-gf=\$DIRECTORY/input/impute/genotype/n${j}_p${k}_chr18.impute \\
	-sf=\$DIRECTORY/input/impute/sv_samples/n${j}.sample_sv \\
	-threads=\$SLURM_NTASKS \\
	-t=time \\
	-c=event \\
	-cov=sex,age,DrugTxYes \\
	-chr=18 \\
	-lstart=\$nstart \\
	-lstop=\$nstop \\
	-method="cox" \\
	-p="onlysnp" \\
	-o=\$DIRECTORY/output/sv/sv_rep${m}/n${j}_p${k}_rep${m}_\${SLURM_ARRAY_TASK_ID}.sv
############################
echo "All Done!"
echo "*************************************************"
echo "SLURM_JOB_ID"=\$SLURM_JOB_ID
echo "SLURM_JOB_NODELIST"=\$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=\$SLURM_NNODES
echo "SLURMTMPDIR"=\$SLURMTMPDIR
echo "working directory"=\$SLURM_SUBMIT_DIR
echo "SLURM_NTASKS"=\$SLURM_NTASKS
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
