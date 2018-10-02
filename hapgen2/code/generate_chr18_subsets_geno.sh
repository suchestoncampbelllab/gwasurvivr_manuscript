#!/bin/bash
cd /gwasurvivr_manuscript/hapgen2/

# Command line input is:
./hapgen2 -h ./CEU.0908.impute.files/CEU.0908.chr18.hap \
    -l ./CEU.0908.impute.files/CEU.0908.chr18.legend \ 
    -m ./CEU.0908.impute.files/genetic_map_chr18_combined_b36.txt \
    -o ./simulated_data/n100 \
    -dl 441 1 1.5 2.5 1124 0 3 4.5 1149 1 2.0 6.5 \
    -n 25 75 

# Command line input is:
./hapgen2 \
    -h ./CEU.0908.impute.files/CEU.0908.chr18.hap \
    -l ./CEU.0908.impute.files/CEU.0908.chr18.legend \
    -m ./CEU.0908.impute.files/genetic_map_chr18_combined_b36.txt \
    -o ./simulated_data/n1000 \
    -dl 97591 1 1.5 2.5 305138 0 3 4.5 328132 1 2.0 6.5 \
    -n 250 750 

# Command line input is:
./hapgen2 \
    -h ./CEU.0908.impute.files/CEU.0908.chr18.hap \
    -l ./CEU.0908.impute.files/CEU.0908.chr18.legend \
    -m ./CEU.0908.impute.files/genetic_map_chr18_combined_b36.txt \
    -o ./simulated_data/n5000 \
    -dl 97591 1 1.5 2.5 305138 0 3 4.5 328132 1 2.0 6.5 \
    -n 800 4200

cd /gwasurvivr_manuscript/hapgen2/simulated_data/
cut -d ' ' -f1-5 --complement n100.cases.gen > n100.cases.gen_slice 
paste n100.controls.gen n100.cases.gen_slice > n100.gen

cut -d ' ' -f1-5 --complement n1000.cases.gen > n1000.cases.gen_slice
paste n1000.controls.gen n1000.cases.gen_slice > n1000.gen

cut -d ' ' -f1-5 --complement n5000.cases.gen  > n5000.cases.gen_slice
paste -d ' ' n5000.controls.gen n5000.cases.gen_slice > n5000.gen

dir=/gwasurvivr_manuscript/benchmark_experiments/data/input/impute/genotypes
for n in 100 1000 5000;
do
	for p in 1000 10000 100000;
	do 
		file="${dir}/n${n}_p${p}.impute"
		echo "creating n${n}_p${p}.impute";
		head -$p n${n}.gen > ${file}; 
done
	done

rm *.cases_gen_slice

exit