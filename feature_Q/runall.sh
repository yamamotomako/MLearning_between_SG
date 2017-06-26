#! /bin/bash

samplepath=$1
outdir=$2


write_usage(){
    echo ""
    echo "bash ./runall.sh 'path of sample and path list(after mutation call, result.filt.txt)' 'path of output directory'"
    echo ""
}



if [ $# -ne 2 ]; then
    echo ""
    write_usage
    exit
fi

if [ ! -e ${samplepath} ]; then
    echo "samplepath file does not exist."
    write_usage
    exit
fi



#ディレクトリ作成、ファイルコピーetc
bash ./prepare.sh ${samplepath} ${outdir}


#define result directory of categorize(ABC)
#mutation分類後のディレクトリ
bash ./make_category.sh ${outdir}


#snp database indexを作成（今回はtumorから）
bash ./make_snp_db.sh ${outdir}/sample_T_list.csv ${outdir}



mkdir -p ${outdir}/mutation_categ

#分類したディレクトリの名称変更(A:somatic, B:germline, C:others)
mv ${outdir}/filt_tn_1 ${outdir}/mutation_categ/A
mv ${outdir}/filt_n_2_ok ${outdir}/mutation_categ/B
mv ${outdir}/filt_n_2_ng ${outdir}/mutation_categ/C


categ_dir=${outdir}/mutation_categ



mkdir -p ${outdir}/addsnp/A ${outdir}/addsnp/B ${outdir}/addsnp/C
mkdir -p ${outdir}/ccount/A ${outdir}/ccount/B ${outdir}/ccount/C


#SNP情報を付与
#ここは遅いから並列化した方がいいかも
python ./add_1MbpSNP.py ${categ_dir}/A ${outdir}/addsnp/A
python ./add_1MbpSNP.py ${categ_dir}/B ${outdir}/addsnp/B
python ./add_1MbpSNP.py ${categ_dir}/C ${outdir}/addsnp/C


#コホート中で同一変異の座標染色位置をカウント
python ./get_cohort_count.py ${outdir}/sample_TN_list.csv ${outdir}/cohort_count_tumor_normal.txt
python ./get_cohort_count.py ${outdir}/sample_N_list.csv ${outdir}/cohort_count_normal.txt


#コホート情報を付与
python ./add_cohort_count.py ${outdir}/addsnp/A ${outdir}/ccount/A ./cohort_count_tumor_normal.txt
python ./add_cohort_count.py ${outdir}/addsnp/B ${outdir}/ccount/B ./cohort_count_normal.txt
python ./add_cohort_count.py ${outdir}/addsnp/C ${outdir}/ccount/C ./cohort_count_normal.txt




#choose featured column from mutation result
python ./choose_feature_column.py "A" ${outdir}/ccount/A ${outdir}/somatic.txt
python ./choose_feature_column.py "B" ${outdir}/ccount/B ${outdir}/germline.txt
python ./choose_feature_column.py "C" ${outdir}/ccount/C ${outdir}/others.txt


somatic_linecount=`cat ${outdir}/somatic.txt | wc -l`

tail -n +2 ${outdir}/germline.txt | shuf -n ${somatic_linecount} > ${outdir}/g.tmp
tail -n +2 ${outdir}/others.txt | shuf -n ${somatic_linecount} > ${outdir}/o.tmp


cat ${outdir}/somatic.txt ${outdir}/g.tmp ${outdir}/o.tmp > ${outdir}/result_all.txt


rm -r ${outdir}/g.tmp ${outdir}/o.tmp




