#! /usr/bin/env python

import os, sys, re

if len(sys.argv) != 4:
    print "Usage: python categorize.py ./input_dir ./output_file_path category"
    quit()

category = sys.argv[1]
inputdir = sys.argv[2]
outfile = sys.argv[3]

c = category

#misRate_tumor
if c == "A":
    col_misrate = 58
elif c == "B":
    col_misrate = 54
else:
    col_misrate = 54


#depth_tumor
if c == "A":
    col_depth = 50
elif c == "B":
    col_depth = 50
else:
    col_depth = 50


#variantNum_tumor
if c == "A":
    col_variant = 51
elif c == "B":
    col_variant = 51
else:
    col_variant = 51


#snp138
if c == "A":
    col_snp = 19
elif c == "B":
    col_snp = 19
else:
    col_snp = 19

#cosmic70
if c == "A":
    col_cosmic = 23
elif c == "B":
    col_cosmic = 23
else:
    col_cosmic = 23

#ExAc frequency
if c == "A":
    col_exac = 91
elif c == "B":
    col_exac = 80
else:
    col_exac = 80

#misRate_otherSNP
if c == "A":
    col_misrate_snp = 96
elif c == "B":
    col_misrate_snp = 85
else:
    col_misrate_snp = 85




result = open(outfile, "w")

#header
arr = ["sample","chr","start","ref","alt","category","dbSNP","cosmic","ExAC","misRate","depth","variantNum","misRate_otherSNP","depth_otherSNP","variantNum_otherSNP","cohoto_count"]
result.write("\t".join(arr) + "\n")


files = os.listdir(inputdir)
for file in files:
    with open(inputdir + "/" + file, "r") as f:
        for line in f:
            sample = re.sub(r"[N|T].genomon_mutation.result.filt.txt", "", file)
            data = line.split("\t")
            chrm = data[0]
            start = data[1]
            #end = data[2]
            ref = data[3]
            alt = data[4]
            dbsnp = data[col_snp]
            cosmic = data[col_cosmic]
            exac = data[col_exac]            
            misrate = data[col_misrate]
            depth = data[col_depth]
            variantnum = data[col_variant]
            misrate_othersnp = data[col_misrate_snp]
            depth_othersnp = data[col_misrate_snp + 1]
            variant_othersnp = data[col_misrate_snp + 2]
            cohoto_count = data[col_misrate_snp + 3]


            dbsnp_flag = False
            cosmic_all = 0

            if dbsnp != "":
                dbsnp_flag = True

            if cosmic != "":
                cosmic_slice = cosmic[cosmic.find("OCCURENCE="):]
                cosmic_num = re.compile(r"\d").findall(cosmic_slice)
                for num in cosmic_num:
                    cosmic_all += int(num)

            if exac == "---":
                exac = 0

            arr = [sample, chrm, start, ref, alt, category, str(dbsnp_flag), str(cosmic_all), str(exac), str(misrate), str(depth), str(variantnum), misrate_othersnp, depth_othersnp, variant_othersnp, str(cohoto_count)]
            result.write("\t".join(arr))

result.close()











