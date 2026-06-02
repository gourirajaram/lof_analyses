project="project-GyJ8Z08JVByxBJyxb0fBx56P"

dx run swiss-army-knife \
    -iin="${project}:/create_annot/misannotation_loci_hg19.bed" \
    -iin="${project}:/create_annot/hg19ToHg38.over.chain" \
    -iimage_file="${project}:/create_annot/liftover.tar.gz" \
    -imount_inputs=true \
    -icmd="
    
    BED_FILE=\$(find . -name \"*.bed\" | head -1)
    CHAIN_FILE=\$(find . -name \"*.chain\" | head -1)
        
    liftOver \$BED_FILE \$CHAIN_FILE misannotation_loci_hg38.bed misannotation_loci_unmapped.bed
    " \
    --destination "${project}:/create_annot/" \
    --instance-type mem1_ssd1_v2_x8 \
    --priority high \
    --name "LiftOver hg19 to hg38" \
    --yes