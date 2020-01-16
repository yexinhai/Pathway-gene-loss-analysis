#!/usr/bin/python

from sys import argv

with open (argv[1]) as specisekolist:
	kolist = specisekolist.readlines()

kolist_new =[]

for line in kolist:
	line = line.strip()
	kolist_new.append(line)

with open (argv[2]) as pathway:
	pathway_raw = pathway.readlines()

for line in pathway_raw:
	if line[0] == 'K':
		line = line.strip()
		if line in kolist_new:
			print (str(line) + "\t" + "+")
		else:
			print (str(line) + "\t" + "x")
	else:
		line = line.strip()
		print (line)