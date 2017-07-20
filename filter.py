#! /usr/bin/python3.5

# A short python script for grabbing genes and their logFC that match 
# between rn4 and rn6, and saving the logFCs to a csv file

# for reading and writing to csv files
import csv

# for selecting an imput file
from tkinter import filedialog as filechooser

# read the csv files with the significant DEGs
rn4file = csv.DictReader(open(filechooser.askopenfilename(),"r"))
rn6file = csv.DictReader(open(filechooser.askopenfilename(),"r"))

# file for the output
outfile = csv.DictWriter(open(filechooser.asksaveasfilename(),"w"), fieldnames=['rn4', 'rn6'])
outfile.writeheader()

# declare the lists to be used for the analysis
rn4, rn6 = [], []

# build rn4 list
for row in rn4file:
    rn4.append((row['Gene_ID'], row['logFC']))

# build rn6 list
for row in rn6file:
    rn6.append((row['Gene_ID'], row['logFC']))

# iterate through each list and write to a csv only the matching genes' logFC
for i in rn4:
    for j in rn6:
        if j[0] in i:
            outfile.writerow({'rn4': i[1], 'rn6': j[1]})
            print(i[0], "\t", j[0]) # proof it's only the matching genes
