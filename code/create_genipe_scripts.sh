dir="/data/scripts/genipe_impute";
output_dir="/data/output";
for m in `seq 1 3`;
do
	for j in 100 1000 5000;
	do
		for k in 1000 10000 100000;
		do
			file="${dir}/genipe_n${j}_p${k}_rep${m}.slurm";
			echo "generating SLURM scripts for genipe trials n${j}_p${k}_rep${m}";

if [ $k == 1000 ]
then 
	mem=24000;
	walltime=`expr 24:00:00`;
elif [ $k == 10000 ] 
then
	mem=24000;
	walltime=`expr 48:00:00`;
elif [ $k == 100000 ]
then
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
#SBATCH --job-name=genipe_n${j}_p${k}_rep${m}
#SBATCH --output=${output_dir}/genipe/results2/log/genipe_n${j}_p${k}_rep${m}_%j.out
#SBATCH --error=${output_dir}/genipe/results2/log/genipe_n${j}_p${k}_rep${m}_%j.err
#Get date and time
tstart=\$(date +%s)
echo "###### start time:"\`date\`
#####################
module load python/anaconda2-4.2.0
module load genipe/1.3.1
source activate py34-genipe
DIRECTORY=/data/
imputed-stats cox \\
    --impute2 \$DIRECTORY/input/impute/genotype/n${j}_p${k}_chr18.impute \\
    --sample \$DIRECTORY/input/impute/sample/n${j}.impute_sample \\
    --pheno \$DIRECTORY/input/impute/covariates/n${j}_cov.phenotype \\
    --out \$DIRECTORY/output/genipe/results2/n${j}_p${k}_rep${m}.genipe \\
    --nb-process \$SLURM_NTASKS \\
    --nb-lines ${k} \\
    --prob 0 \\
    --maf 0 \\
    --gender-column sex \\
    --covar age,DrugTxYes,sex \\
    --sample-column ID_2 \\
    --time-to-event time \\
    --event event
#####################
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

echo -e "\tsub file: ${file}\n";
sbatch ${file} --constraint=CPU-L5520 --exclusive;
		done
	done
done
