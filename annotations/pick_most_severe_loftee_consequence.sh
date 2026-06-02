project="project-GyJ8Z08JVByxBJyxb0fBx56P"

input_file_names=()
chromosomes=( $(seq 1 22) X Y )
for chrom in "${chromosomes[@]}"
do
    input_file_names+=("-iin=${project}:/Annotations/wes_sites_annotated/ukb23159_c${chrom}_b0_v1_sites_annotated_loftee_flat.csv")
done

dx run swiss-army-knife \
    "${input_file_names[@]}" \
    -iin="${project}:/softwares_latest/pick_most_severe_loftee_consequence.py" \
    -imount_inputs=true \
    -icmd="
    tmp_dir=\$(mktemp -d) ;    

    pip install pyarrow pandas dask ;

    chromosomes=( \$(seq 1 22) X Y ) ;
    cat_file_names=() ;
    for chrom in \"\${chromosomes[@]}\" ;
    do 
        python3 pick_most_severe_loftee_consequence.py ukb23159_c\${chrom}_b0_v1_sites_annotated_loftee_flat.csv \${tmp_dir}/ukb23159_c\${chrom}_b0_v1_sites_annotated_loftee_most_severe_consequences.csv ;

        cat_file_names+=(\"\${tmp_dir}/ukb23159_c\${chrom}_b0_v1_sites_annotated_loftee_most_severe_consequences.csv\") ;
    done ;

    echo \"ID,Gene_Name,Gene_ID,Consequence\" > ukb23159_b0_v1_sites_annotated_loftee_most_severe_consequences.csv ;

    cat \${cat_file_names[@]} >> ukb23159_b0_v1_sites_annotated_loftee_most_severe_consequences.csv ;
    " \
    --destination "${project}:/Annotations/LoFs_most_severe_conseq/" \
    --instance-type mem2_ssd2_v2_x16 \
    --priority high \
    --name "Pick Most Severe LOFTEE Consequence" \
    --yes
