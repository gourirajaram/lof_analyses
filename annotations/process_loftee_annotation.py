import os
import sys

import pandas as pd
import dask
import dask.dataframe as dd
from tqdm import tqdm


def process(chunk):
    
    # Reset index
    chunk = chunk.reset_index(drop=True)
    
    # Remove CSQ= tag from annotations
    chunk.INFO = chunk.INFO.str.replace('CSQ=', '')
    
    # Split multiple annotations per variant into multiple lines
    info_line_split = chunk.INFO.str.split(',').apply(pd.Series, 1).stack()
    info_line_split.index = info_line_split.index.droplevel(-1)
    info_line_split.name = 'CSQ'
    del chunk['INFO']
    chunk = chunk.join(info_line_split)
    
    del info_line_split
    
    # Expand annotation into columns
    csq_expanded = chunk.CSQ.str.split('|', expand=True).fillna('')
    expanded_names = [
        'Allele', 'Consequence', 'IMPACT', 'SYMBOL', 'Gene', 'Feature_type',
        'Feature', 'BIOTYPE', 'EXON', 'INTRON', 'HGVSc', 'HGVSp',
        'cDNA_position', 'CDS_position', 'Protein_position', 'Amino_acids',
        'Codons', 'Existing_variation', 'DISTANCE', 'STRAND', 'FLAGS',
        'SYMBOL_SOURCE', 'HGNC_ID', 'LoF', 'LoF_filter', 'LoF_flags', 'LoF_info'
    ]

    chunk[expanded_names] = csq_expanded
    del chunk['CSQ'], csq_expanded, expanded_names
    
    # Label pLoFs
    chunk['pLoF'] = chunk.LoF == 'HC'
    
    # Label missense variants
    missense = [False] * len(chunk)
    for i, consequence in enumerate(chunk.Consequence):
        if 'missense_variant' in consequence.split('&'):
            missense[i] = True

    chunk['missense'] = missense

    del missense

    # Label synonymous variants
    synonymous = [False] * len(chunk)
    for i, consequence in enumerate(chunk.Consequence):
        if 'synonymous_variant' in consequence.split('&'):
            synonymous[i] = True

    chunk['synonymous'] = synonymous

    del synonymous
    
    # Filter to only pLoFs, missense, and synonymous variants
    chunk = chunk[chunk.pLoF | chunk.missense | chunk.synonymous]
    
    return chunk


def main():

    file_path = sys.argv[1]
    output_path = sys.argv[2]

    CHUNK_LINES = 10000
    
    with pd.read_table(
        file_path,
        chunksize=CHUNK_LINES, comment='#', sep='\t', engine='c', header=None,
        usecols=[2, 7], names=['ID', 'INFO']
    ) as reader:
        
        with open(output_path, 'a') as f_out:
            
            first_chunk = True
        
            for chunk in tqdm(reader):
                
                chunk = dd.from_pandas(chunk, npartitions=7)
    
                delayed_objects = [dask.delayed(process)(partition) for partition in chunk.to_delayed()]
                chunk = dask.compute(*delayed_objects, scheduler='processes')
                chunk = pd.concat(chunk)
    
                # Write to disk
                if first_chunk:
                    chunk.to_csv(f_out, index=None)
                    first_chunk = False
                else:
                    chunk.to_csv(f_out, index=None, header=None)

if __name__ == '__main__':

    main()
