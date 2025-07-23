#!/bin/bash

sed -n 2,135p columbia.csv | gawk -F'\t' '{printf("%s\t%s\n",NR,$0)}' >msql_tmp.txt

#col_prox_ftrs: list of col disease-feature links with cui and their ids. [cui, ftr, ftr_id, case_id]

>col_prox_ftrs.txt
while read -r NUMNR 
do
#	NUMNR=2
	echo "$NUMNR"
	gawk -F'\t' -v VAR=$NUMNR '{if($1==VAR)printf("%s\n",$2)}' msql_tmp.txt >msql_tmp1.txt
	tr ',' '\n' <msql_tmp1.txt >msql_tmp2.txt
	gawk -F'\t' '{printf("%s\t%s\n",NR,$0)}' msql_tmp2.txt >msql_tmp3.txt	
	gawk -F'\t' '{if($2 > 0)printf("%s\n",$0)}' msql_tmp3.txt >msql_tmp4.txt
	
	TOT_ROWS=$(wc -l <msql_tmp4.txt)
	TOT_ROWS1=$( expr $TOT_ROWS - 1 )
	TOT_ROWS2=(","$TOT_ROWS1"p")	
	sed -n 2$TOT_ROWS2 msql_tmp4.txt >msql_tmp5.txt
	
	gawk -F'\t' 'NR==FNR{a[$1]=$2;b[$1]=$3;next}a[$1]>0{printf("%s\t%s\t%s\n",a[$1],b[$1],$1)}' col_ftrs1.txt msql_tmp5.txt >msql_tmp6.txt
	gawk -F'\t' -v VAR=$NUMNR '{printf("%s\t%s\n",$0,VAR)}' msql_tmp6.txt >>col_prox_ftrs.txt
	
done <col_134.txt

#col_mrhier_prox: [cui_diag,aui_diag,pos_diag, pos_ftr,ftr_id, case_id, ftr_def]
#                     1       2        3         4        5       6      7

>col_mrhier_prox.txt
while read -r NUMNR 
do
#	NUMNR=1
	echo "$NUMNR"
	gawk -F'\t' -v VAR=$NUMNR '{if($4 == VAR)printf("%s\n",$0)}' col_prox_ftrs.txt >msql_tmp7.txt 
	gawk -F'\t' 'NR==FNR{a[$1]=$2;b[$1]=$3;c[$1]=$4;next}a[$1]>0{printf("%s\t%s\t%s\t%s\t%s\t%s\n",$2,$1,$3,b[$1],c[$1],a[$1])}' msql_tmp7.txt col_mrhier.txt >msql_tmp8.txt
	gawk -F'\t' 'NR==FNR{a[$1]=$2;b[$1]=$3;c[$1]=$4;d[$1]=$5;e[$1]=$6;next}a[$1]>0{printf("%s\t%s\t%s\t%s\t%s\t%s\t%s\n",$2,$1,$3,b[$1],c[$1],d[$1],e[$1])}' msql_tmp8.txt col_mrhier_diag1.txt >>col_mrhier_prox.txt	
done <col_134.txt



>col_prox_corpus.txt
while read -r NUMNR 
do
#	NUMNR=1
	echo "$NUMNR"
	gawk -F'\t' -v VAR=$NUMNR '{if($6 == VAR)printf("%s\n",$0)}' col_mrhier_prox.txt >msql_tmp9.txt 
	gawk -F'\t' 'NR==FNR{a[$1]=$2;b[$1]=$3;next}a[$1]>0{printf("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",$2,b[$1],$3,$4,$5,$6,$7,a[$1])}' col_diag1nr.txt msql_tmp9.txt >msql_tmp10.txt
	gawk -F'\t' 'NR==FNR{a[$1]=$2;next}a[$1]>0{printf("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",$2,a[$1],$3,$4,$5,$6,$7,$8)}' col_aui_nr.txt msql_tmp10.txt >msql_tmp11.txt
	gawk -F'\t' '{printf("%s\t%s\t%s\t%s\t%s\t%s\n",$1,$2,$3,$4,$5,$6)}' msql_tmp11.txt | sort -n -k1,1 >>col_prox_corpus.txt
done <col_134.txt
