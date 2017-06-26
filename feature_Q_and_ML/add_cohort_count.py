#! /usr/bin/env python

import sys
import os
import pysam
#import tabix

inpdir = sys.argv[1]
outdir = sys.argv[2]
coresult = sys.argv[3]

ref_dict = {}

with open(coresult, "r") as f:
    for line in f:
        data = line.split("\t")
        ref_dict[data[0]] = data[1]




for file in os.listdir(inpdir):

    samplename = file.rstrip("\n").replace(".genomon_mutation.result.filt.txt", "")
    print "add cohot count: " + samplename

    with open(inpdir + "/" + file, "r") as f:
        g = open(outdir + "/" + samplename + ".genomon_mutation.result.filt.txt", "w")

        for line in f:
            data = line.split("\t")
            chrm = data[0]
            start = data[1]
            end = data[2]
            ref = data[3]
            alt = data[4]

            key = chrm+"_"+start+"_"+end+"_"+ref+"_"+alt

            if key in ref_dict:
                cohot_count = ref_dict[key]
            else:
                cohot_count = "0"

            g.write(line.rstrip("\n") + "\t" + cohot_count)


        g.close()





