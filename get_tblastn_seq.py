#!/usr/bin/python

from sys import argv
import re

with open (argv[1]) as ref_fasta:
	list1 = ref_fasta.readlines()

anno_dict = {}

for line in list1:
	if line[0] == '>':
		line = line.strip()
		gene = re.search(r'>(\S+)\t(K\d+).*$',line).group(1)
		ko_anno = re.search(r'>(\S+)\t(K\d+).*$',line).group(2)
		anno_dict[gene] = ko_anno

with open (argv[2]) as genome:
	list2 = genome.readlines()

genome_dict = {}

for line in list2:
	line = line.strip()
	if line[0] == '>':
		scaffold = re.search(r'>(\S+)\s.*$', line).group(1)
		genome_dict[scaffold] = ''
	else:
		genome_dict[scaffold] += line

with open (argv[3]) as tblasn:
	list3 = tblasn.readlines()

for line in list3:
	line = line.strip()
	gene1 = line.split('\t')[0]
	qcovs = line.split('\t')[-1]
	scaf = line.split('\t')[1]
	start = line.split('\t')[8]
	end = line.split('\t')[9]
	if int(qcovs) > 50:
		if int(end) > int(start):
			seq = str(genome_dict[scaf])[int(start)-1:int(end)].upper()
			print (">" + str(scaf) + "_#" + str(start) + "_" + str(end) + "#_" + str(anno_dict[gene1]) + "\n" + str(seq))
		else:
			seq = str(genome_dict[scaf])[int(end)-1:int(start)].upper()
			seq_r = seq[::-1].replace('A','t').replace('T','a').replace('G','c').replace('C','g').upper()
			print (">" + str(scaf) + "_#" + str(start) + "_" + str(end) + "#_" + str(anno_dict[gene1]) + "\n" + str(seq_r))

