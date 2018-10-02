############################################################
### start ##################################################

cd /gwasurvivr_manuscript/hapgen2/


############################################################
### N = 9K #################################################
while IFS="," read -r chr hit
do
	echo $chr
	./hapgen2 \
		-h ./CEU.0908.impute.files/CEU.0908.chr$chr.hap \
		-l ./CEU.0908.impute.files/CEU.0908.chr$chr.legend \
		-m ./CEU.0908.impute.files/genetic_map_chr$chr\_combined_b36.txt \
		-o ./gwasurvivr/N_9K/chr$chr \
		-dl $hit \
		-n 6000 3000 \
		-no_haps_output
	echo "stitching files..."
	cut -d ' ' -f1-5 --complement ./gwasurvivr/N_9K/chr$chr.cases.gen > ./gwasurvivr/N_9K/chr$chr.cases.gen_slice
	paste -d ' ' ./gwasurvivr/N_9K/chr$chr.controls.gen ./gwasurvivr/N_9K/chr$chr.cases.gen_slice > ./gwasurvivr/N_9K/n9K.chr$chr.gen
	echo "zipping files..."
	gzip ./gwasurvivr/N_9K/n9K.chr$chr.gen
	echo "removing files"
	rm -rf ./gwasurvivr/N_9K/chr$chr.cases*
	rm -rf ./gwasurvivr/N_9K/chr$chr.controls*

done < "/gwasurvivr_manuscript/hapgen2/code/HitChr.csv"

while IFS="," read -r chr hit
do
	echo $chr
	./hapgen2 \
		-h ./CEU.0908.impute.files/CEU.0908.chr$chr.hap \
		-l ./CEU.0908.impute.files/CEU.0908.chr$chr.legend \
		-m ./CEU.0908.impute.files/genetic_map_chr$chr\_combined_b36.txt \
		-o ./gwasurvivr/N_9K/chr$chr \
		-dl $hit \
		-n 6000 3000 \
		-no_haps_output
	echo "stitching files..."
	cut -d ' ' -f1-5 --complement ./gwasurvivr/N_9K/chr$chr.cases.gen > ./gwasurvivr/N_9K/chr$chr.cases.gen_slice
	paste -d ' ' ./gwasurvivr/N_9K/chr$chr.controls.gen ./gwasurvivr/N_9K/chr$chr.cases.gen_slice > ./gwasurvivr/N_9K/n9K.chr$chr.gen
	echo "zipping files..."
	gzip ./gwasurvivr/N_9K/n9K.chr$chr.gen
	echo "removing files"
	rm -rf ./gwasurvivr/N_9K/chr$chr.cases*
	rm -rf ./gwasurvivr/N_9K/chr$chr.controls*

done < "/gwasurvivr_manuscript/hapgen2/code/nonHitChr.csv"





