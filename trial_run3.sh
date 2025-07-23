#!/bin/bash

TOT_ROWS=$(wc -l < col_prox_def4.txt)
TOT_DATA=(","$TOT_ROWS"p")
sed -n 9$TOT_DATA col_prox_def4.txt >msql_tmp.txt

gawk -F'\t' '{printf("%s\t%s\t%s\t%s\t%s\t%s\n",$3,$7,$5,$8,$11,$2)}' msql_tmp.txt >msql_tmp1.txt
                                                                                                        
gawk -F'\t' '{printf("%s\t%s\n",NR,$0)}' msql_tmp1.txt >msql_tmp2.txt
cat header.txt msql_tmp2.txt >msql_tmp3.txt

python pairs_cnn1.py
