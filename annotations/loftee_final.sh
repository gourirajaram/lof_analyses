project="project-GyJ8Z08JVByxBJyxb0fBx56P"

chromosomes=( $(seq 1 22) X Y )
for chrom in "${chromosomes[@]}"
do
    dx run swiss-army-knife \
        -iin="${project}:/Sites_loftee/ukb23159_c${chrom}_b0_v1_sites.vcf" \
        -iin="${project}:/loftee_test/loftee_ref_hg38_files/gerp_conservation_scores.homo_sapiens.GRCh38.bw" \
        -iin="${project}:/loftee_test/loftee_ref_hg38_files/human_ancestor.fa.gz" \
        -iin="${project}:/loftee_test/loftee_ref_hg38_files/human_ancestor.fa.gz.fai" \
        -iin="${project}:/loftee_test/loftee_ref_hg38_files/human_ancestor.fa.gz.gzi" \
        -iin="${project}:/loftee_test/loftee_ref_hg38_files/loftee.sql" \
        -iimage_file="${project}:/softwares_latest/loftee.tar.gz" \
        -icmd="
        vep \
            --plugin LoF,loftee_path:/home/root/loftee/,gerp_bigwig:gerp_conservation_scores.homo_sapiens.GRCh38.bw,human_ancestor_fa:human_ancestor.fa.gz,conservation_file:loftee.sql \
            --dir_plugins /home/root/loftee/ \
            --vcf \
            --input_file ukb23159_c${chrom}_b0_v1_sites.vcf \
            --output_file ukb23159_c${chrom}_b0_v1_sites_annotated_loftee.vcf \
            --database \
            --db_version 105 ;
            
        " \
        --destination "${project}:/Annotations/WES/" \
        --instance-type mem1_ssd2_v2_x8 \
        --priority high \
        --name "Annotate LoFs with LOFTEE" \
        --yes
done 
