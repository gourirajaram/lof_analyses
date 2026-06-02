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
    freq_files=()
    for chrom in \"\${chromosomes[@]}\" ;
        do
            
            plink2 \
                --bgen ukb23159_c\${chrom}_b0_v1.bgen ref-first \
                --sample ukb23159_c\${chrom}_b0_v1.sample \
                --memory 30000 \
                --threads 32 \
                --freq \
                --out \${tmp_dir}/ukb23159_c\${chrom}_b0_v1 ;

            sed -i '1d' \${tmp_dir}/ukb23159_c\${chrom}_b0_v1.afreq ;

            freq_files+=(\"\${tmp_dir}/ukb23159_c\${chrom}_b0_v1.afreq\") ;
    done ;

    cat \${freq_files[@]} > ukb23159_WES_allele_frequencies.afreq
    " \
    --destination "${project}:/Genotypes/WES/" \
    --instance-type mem2_ssd2_v2_x8 \
    --priority high \
    --name "WES Allele Frequencies" \
    --yes
