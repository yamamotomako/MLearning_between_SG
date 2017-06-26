#! /usr/bin/env python

import sys
import os


inpdir = sys.argv[1]
outdir = sys.argv[2]


with open(inpdir, "r") as h:
    for line in h:
        samplename = line.split(",")[0]
        file = line.split(",")[1]

        with open(file, "r") as f:
            g = open(outdir + "/" + samplename + ".filt.snp", "w")

            header = ["chr", "start", "end", "ref", "alt", "misRate_tumor", "depth_tumor", "variantNum_tumor"]
            g.write("\t".join(header) + "\n")

            #remove header
            cnter = 0
            for line in f:
                cnter += 1
                if cnter < 5:
                    continue

                data = line.strip().split("\t")
                chrm = data[0]
                start = data[1]
                end = data[2]
                ref = data[3]
                alt = data[4]
                snp138 = data[19]
                exac = data[80]
                misrate_t = data[54]
                depth_t = data[50]
                variant_t = data[51]

                if ref == "-" or alt == "-":
                    continue

                if snp138 != "":
                    if exac != "---" and float(exac) >= 0.01:
                        tmp = ["chr"+chrm, start, end, ref, alt, misrate_t, depth_t, variant_t]
                        g.write("\t".join(tmp) + "\n")


            g.close()

