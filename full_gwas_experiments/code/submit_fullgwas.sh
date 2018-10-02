dir="/gwasurvivr_manuscript/full_gwas_experiments/code";
output_dir="/gwasurvivr_manuscript/full_gwas_experiments/results";

for j in 3000 6000 9000;
do
	for k in `seq 1 22`;
	do
		file="${dir}/scripts/full_gwas_chr${k}_n${j}.slurm";
		echo "generating SLURM scripts for full gwas IMPUTE2 trials chr${m}_n${j}";

cat <<EOM > ${file}
#!/bin/bash
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=24000
#SBATCH --mail-user=user.name@university.eduu
#SBATCH --mail-type=FAIL
#SBATCH --partition=general-compute --qos general-compute
#SBATCH --job-name=n${j}_chr${k}
#SBATCH --output=${output_dir}/log/n${j}_chr${k}_%j.out
#SBATCH --error=${output_dir}/log/n${j}_chr${k}_%j.err
#Get date and time
tstart=\$(date +%s)
echo "###### start time:"\`date\`
#####################

DIRECTORY=/gwasurvivr_manuscript/full_gwas_experiments/data
SCRIPT=/gwasurvivr_manuscript/full_gwas_experiments/code

module load R

R --file=\$SCRIPT/run_fullgwas.R -q --args \\
	impute.file \$DIRECTORY/genetic_data/n9K.chr${k}.gen.gz \\
	chr ${k} \\
	sample.ids \$DIRECTORY/sample_ids/n${j}_sample_ids.txt \\
	out.file \$DIRECTORY/results/n${j}_chr${k}.res \\
	ncores \$SLURM_NTASKS



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
sbatch ${file} ;
	done
done

