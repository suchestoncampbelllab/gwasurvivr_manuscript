dir="/projects/rpci/lsuchest/ezgi/gwasurvivr_sims/run_bigNs/code";
for bigN in 15 20 25;
do
	file="${dir}/run_${bigN}K.sh";
	echo "generating SLURM script for gwasurvivr ${bigN}K";
 
cat <<EOM > ${file}
#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --tasks-per-node=12
#SBATCH --mem=48000
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=rizvi.33@osu.edu
#SBATCH --mail-type=FAIL
#SBATCH --partition=general-compute --qos=general-compute
#SBATCH --job-name=gwasurvivr_bigNs
#SBATCH --output=/projects/rpci/lsuchest/ezgi/gwasurvivr_sims/run_bigNs/log/${bigN}K_%j.out
#SBATCH --error=/projects/rpci/lsuchest/ezgi/gwasurvivr_sims/run_bigNs/log/${bigN}K_%j.err

#Get date and time
tstart=\$(date +%s)
echo "###### start time:"\$tstart

DIRECTORY=/projects/rpci/lsuchest/ezgi/gwasurvivr_sims/run_bigNs

########


module load R

R --file=\$DIRECTORY/code/run_bigNs.R -q --args \\
	impute.file /projects/rpci/lsuchest/ezgi/gwasurvivr_sims/compress_bigNs/genetic_data/N_${bigN}K.gen.gz \\
	sample.file \$DIRECTORY/sample_files/N_${bigN}K.sample \\
	covariate.file \$DIRECTORY/pheno_files/N${bigN}K_pheno.txt \\
	out.file \$DIRECTORY/result_files/N${bigN}K 


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
sbatch ${file} 

done

