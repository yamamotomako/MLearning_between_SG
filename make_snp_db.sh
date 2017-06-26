#! /bin/bash

samplepath=$1
outdir=$2



f_snp=${outdir}/filt_snp
f_snp_sort=${outdir}/filt_snp_sort
f_bgzip=${outdir}/filt_bgzip


mkdir -p ${outdir}
mkdir -p ${f_snp}
mkdir -p ${f_snp_sort}
mkdir -p ${f_bgzip}



#choose snp from tumor mutation  result
python ./get_snp.py ${samplepath} ${f_snp}


#make index of snp database
for file in `ls ${f_snp}`; do
    head -n 1 ${f_snp}/${file} > ${f_snp}/${file}.header
    tail -n +2 ${f_snp}/${file} > ${f_snp}/${file}.content

    sort -V -k 1,1 -k 2,2n ${f_snp}/${file}.content > ${f_snp_sort}/${file}.bed

    rm -f ${f_snp}/${file}.header ${f_snp}/${file}.content

    bgzip -c ${f_snp_sort}/${file}.bed > ${f_bgzip}/${file}.gz

    tabix -p bed ${f_bgzip}/${file}.gz

done



