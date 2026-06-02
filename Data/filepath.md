On the `WES_analysis` project on the UKB-RAP <br>
1) `/create_annot/misannotation_hg19.bed` - loci (in _hg19_) that have misannotation probability values downloaded from ``` https://zenodo.org/records/7939768/files/gnomad_lofs_with_misannotation_probabilities.tsv.gz?download=1 ``` <br>
2) `/create_annot/hg19ToHg38.over.chain.gz` - to be used for _liftover_ too to convert from _hg19_ to _hg38_ <br>
3) `/create_annot/misannotation_hg38.bed` - loci (in _hg38_) for downstream analyses <br>
4) `/Genotypes/WES/ukb23159_WES_allele_frequencies.afreq` - allele frequencies of WES variants <br>
5) `/create_annot/consequences_gr_full.csv` - data of misannotation probability values of all annotated LoFs <br>

### Downloads <br>
`https://zenodo.org/records/7939768/files/s_het_estimates.genebayes.tsv?download=1` - _s_het_ values of genes from [Tony and Jeff's paper](https://zenodo.org/records/7939768) <br>
`https://zenodo.org/records/7939768/files/gnomad_lofs_with_misannotation_probabilities.tsv.gz?download=1` - misannotation probability values of _gnomad_ annotated LoFs also calculated in the above _GeneBayes_ paper <br>
