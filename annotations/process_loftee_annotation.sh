project="project-GyJ8Z08JVByxBJyxb0fBx56P"

chromosomes=( $(seq 1 22) X Y )
for chrom in "${chromosomes[@]}"
do

    dx run swiss-army-knife \
        -iin="${project}:/Annotations/WES/ukb23159_c${chrom}_b0_v1_sites_annotated_loftee.vcf" \
        -iin="${project}:/softwares_latest/process_loftee_annotation.py" \
        -imount_inputs=true \
        -icmd="
        pip install pandas dask tqdm ;
    
        python3 process_loftee_annotation.py ukb23159_c${chrom}_b0_v1_sites_annotated_loftee.vcf ukb23159_c${chrom}_b0_v1_sites_annotated_loftee_flat.csv ;
        " \
        --destination "${project}:/Annotations/wes_sites_annotated/" \
        --instance-type mem2_ssd1_v2_x8 \
        --priority high \
        --name "${chrom}_Process LOFTEE Annotations" \
        --yes

done
