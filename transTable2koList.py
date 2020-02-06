#!/usr/bin/python

from sys import argv

with open (argv[1]) as kotable:
	list1 = kotable.readlines()

species = []
ko_and_table_dict = {}

for line in list1:
    line = line.strip()
    a = line.split('\t')
    if a[0] == 'species':
        del a[0]
        species = a
    if a[0][0] == 'K':
        species_ko = a[1:]
        ko_and_table_dict[a[0]] = species_ko

species_num = len(species)

for i in range(0, int(species_num)):
    filename = species[i]+'.txt'
    f = open(filename,'w')
    kolistinspecies = []
    for key in ko_and_table_dict.keys():
        if ko_and_table_dict[key][i] == '+':
            kolistinspecies.append(key)
    for line in kolistinspecies:
        f.write(line+'\n')
    f.close()
