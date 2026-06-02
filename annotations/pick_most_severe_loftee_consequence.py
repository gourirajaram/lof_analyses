import os
import sys

import pandas as pd
import dask
import dask.dataframe as dd


def main():

    file_path = sys.argv[1]
    output_path = sys.argv[2]

    var_annot = pd.read_csv(file_path, engine='pyarrow')
    var_annot = dd.from_pandas(var_annot, npartitions=8)

    # Map each variant-gene pair to the most severe consequence
    def most_severe(r):
        if r.pLoF.any():
            return 'pLoF'
        elif r.missense.any():
            return 'missense'
        else:
            return 'synonymous'
    
    consequences = var_annot.groupby(
        ['ID', 'SYMBOL', 'Gene']
    ).apply(
        most_severe,
        meta=('Consequence', str)
    ).reset_index().compute()

    consequences.to_csv(output_path, index=None, header=None)


if __name__ == '__main__':

    main()
