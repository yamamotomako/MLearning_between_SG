#! /usr/bin/env python

import sys
import os
from collections import OrderedDict


samplepath = sys.argv[1]
resultdir = sys.argv[2]
resultfile = sys.argv[3]
flag = sys.argv[4]


if flag == "TN":
    col_refgene = 5
else:
    col_refgene = 5

if flag == "TN":
    col_misrate = 58
else:
    col_misrate = 54

col_ref = 3
col_alt = 4


g = open(resultfile, "w")

result_dict = OrderedDict()

with open(samplepath, "r") as lines:
    for line in lines:
        sample_name = line.strip().split(",")[0]
        mutation_file = line.strip().split(",")[1]
        print sample_name

        if flag == "TN":
            sample_name_r = sample_name + "_TN"
        elif flag == "N":
            sample_name_r = sample_name + "_N"
        else:
            sample_name_r = sample_name + "_T"

        result_dict[sample_name_r] = 0

        with open(mutation_file, "r") as f:
            gg = open(resultdir + "/" + sample_name + ".genomon_mutation.result.filt.txt", "w")

            #remove header
            cnter = 0
            for line in f:
                cnter += 1
                if cnter < 5:
                    continue

                data = line.strip().split("\t")

                #filter by Func.refGene
                if data[col_refgene] == "exonic" or data[col_refgene] == "splicing" or data[col_refgene] == "exonic;splicing":

                    #filter by misrate
                    if float(data[col_misrate]) >= 0.05:

                        #filter by indel
                        if not data[col_ref] == "-" and not data[col_alt] == "-":
                            #print sample_name, data[0], data[1], data[2], data[6], data[col_misrate], result_dict[sample_name_r]
                            result_dict[sample_name_r] += 1
                            gg.write(line)

            gg.close()



for key, value in result_dict.items():
    g.write(key + "\t" + str(value) + "\n")



g.close()


