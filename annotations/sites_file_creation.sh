project="project-GyJ8Z08JVByxBJyxb0fBx56P"

input_file_names=()
chromosomes=( $(seq 1 22) X Y )
for chrom in "${chromosomes[@]}"
do
    input_file_names+=("-iin=${project}:/Bulk/Exome sequences/Population level exome OQFE variants, BGEN format - final release/ukb23159_c${chrom}_b0_v1.bgen")
    input_file_names+=("-iin=${project}:/Bulk/Exome sequences/Population level exome OQFE variants, BGEN format - final release/ukb23159_c${chrom}_b0_v1.sample")
done

dx run swiss-army-knife \
    "${input_file_names[@]}" \
    -imount_inputs=true \
    -icmd="
    tmp_dir=\$(mktemp -d) ;
    
    chromosomes=( \$(seq 1 22) X Y ) ;
    for chrom in \"\${chromosomes[@]}\" ;
        do plink2 \
            --bgen ukb23159_c\${chrom}_b0_v1.bgen ref-first \
            --sample ukb23159_c\${chrom}_b0_v1.sample \
            --memory 30000 \
            --threads 16 \
            --make-just-pvar cols=vcfheader,qual,filter,info \
            --out \${tmp_dir}/ukb23159_c\${chrom}_b0_v1_sites ;

        mv \${tmp_dir}/ukb23159_c\${chrom}_b0_v1_sites.pvar ukb23159_c\${chrom}_b0_v1_sites.vcf ;
    done ;
    " \
    --destination "${project}:/Sites_loftee/" \
    --instance-type mem2_ssd2_x16 \
    --priority high \
    --name "Extract Exome Sites for Annotation" \
    --yes
