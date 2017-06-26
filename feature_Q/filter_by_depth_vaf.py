#! /usr/bin/env python

import sys
import os


inputdir = sys.argv[1]
ok_resultdir = sys.argv[2]
ng_resultdir = sys.argv[3]
flag = sys.argv[4]


if flag == "TN":
    col_depth = 50
else:
    col_depth = 50

if flag == "TN":
    col_variant = 51
else:
    col_variant = 51




for file in os.listdir(inputdir):
    samplename = file.rstrip("\n").replace(".genomon_mutation.result.filt.txt", "")
    print samplename

    with open(inputdir + "/" + file, "r") as f:
        ok_f = open(ok_resultdir + "/" + file, "w")
        ng_f = open(ng_resultdir + "/" + file, "w")

        #remove header
        cnter = 0
        for line in f:
            data = line.strip().split("\t")

            #filter by depth, vaf
            vaf = float(data[col_variant]) / int(data[col_depth])
            if int(data[col_depth]) >= 20 and vaf >= 0.25:
                ok_f.write(line)
            else:
                ng_f.write(line)

        ok_f.close()
        ng_f.close()



