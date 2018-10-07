######################################################################
### Chr 22 N = 15K, 20K, 25K #########################################

## make sure hapgen2 is installed in /gwasurvivr_manuscript/hapgen2 directory. 
## and have CEU CHR2 reference data available under CEU.0908.impute.files/ from https://mathgen.stats.ox.ac.uk/wtccc-software/CEU.0908.impute.files.tgz

cd /gwasurvivr_manuscript/hapgen2

while IFS="," read -r nsize cases controls
do
	./hapgen2 -h ./CEU.0908.impute.files/CEU.0908.chr22.hap -l ./CEU.0908.impute.files/CEU.0908.chr22.legend -m ./CEU.0908.impute.files/genetic_map_chr22_combined_b36.txt -o ./simulated_data/N_$nsize\K -dl 16207558 1 1.2 2.5 -n $controls $cases -no_haps_output
	echo "stitching files..."
	cut -d ' ' -f1-5 --complement ./simulated_data/N_$nsize\K.cases.gen > ./simulated_data/N_$nsize\K.cases.gen_slice
	paste -d ' ' ./simulated_data/N_$nsize\K.controls.gen ./simulated_data/N_$nsize\K.cases.gen_slice > ./simulated_data/N_$nsize\K.gen
	echo "zipping files..."
	gzip ./simulated_data/N_$nsize\K.gen
	echo "removing files"
	rm -rf ./simulated_data/N_$nsize\K.cases*
	rm -rf ./simulated_data/N_$nsize\K.controls*
done < "/gwasurvivr_manuscript/largeN_experiments/code/Ns_15K_20K_25K.csv"
