Scripts to <br> a) Annotate variants in whole-exome sequencing data using Ensembl's [Variant Effect Predictor](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-016-0974-4#:~:text=The%20VEP%20is%20a%20software,a%20subset%20for%20further%20analysis) with the [LOFTEE plugin](https://github.com/konradjk/loftee) <br> b) Prepare files to identify individuals carrying loss-of-function (LoF) variant burden mask using [REGENIE](https://rgcgithub.github.io/regenie/) <br> <br>

### Scripts to be implemented in the following order <br>
1. `wes_allele_frequencies_gr_1.sh` - reports frequency of the alternate allele. The first column considered reference allele with _ref_first_ <br><br>
**For loftee annotated variants:** <br>
2.  `loftee_download_docker.sh` - to be run on UKB-RAP. Downloads docker image of [loftee](https://hub.docker.com/r/nikhilmilind/loftee) from docker hub <br>
3.  `sites_file_creation.sh` - For each chromosome, extract only site metadata (REF, ALT, QUAL, INFO), and create a _.vcf_ file from the _.bgen_ files. Prepares the sites information needed for downstream annotation <br>
4. `loftee_final.sh` - outputs _.vcf_ file with VEP+LOFTEE annotations of variants <br><br>
**Processing loftee output:** <br>
5. `process_loftee_annotation.sh` & `process_loftee_annotation.py` - read the _.vcf_ file in chunks, extracts and expand the VEP CSQ annotations to identify and label _pLoF_, _missense_, and _synonymous_ variants and save to _.csv_ format <br>
6. `pick_most_severe_loftee_consequence.sh` & `pick_most_severe_loftee_consequence.py` - the above created _.csv_ file has 3 columns _pLoF_, _missense_, _synonymous_. For each variant ID, it gives True/False for each of these columns. This code snippet picks up the True column for each variant and calls it the most severe consequence. Results in a combined _.csv_ file, with consequence information from variants of all chromosomes <br><br>
**Liftover : to convert genomic coordinates from hg19 to hg38 reference genome** <br>
7. `liftOver_docker_download.sh` - download docker image of the [liftover tool](https://hub.docker.com/r/vanallenlab/liftover). Run on UKB-RAP <br>
8. `liftover_files_download.ipynb` - download files necessary for liftover <br>
9. `liftover.sh` - run on terminal with `dxtoolkit` installed <br><br>
**Annotations files creation** <br>
10. `annotations_lof_create_gr.ipynb` - calculate misannotation probabilities of variants based off [GeneBayes paper](https://pmc.ncbi.nlm.nih.gov/articles/PMC10245655/). <br> The above code also creates _annotations_ , _sets_, and _masks_ files for regenie step2 analysis (i.e LoF individual carriers identification)<br> <br>
#### To annotate LoF variants in the data and calculate their misannotation probability values , 1) to 10) have to be run <br>

