#!/usr/bin/python
from __future__ import print_function
import os 
adict = {}
ko_list =[]
for line in open('tblastn_all_ko.fasta','r'):
	line =line.strip()
	if line.startswith('>') :
		id = line[1:]
		adict[id] = ''
		ko_list.append(line.split('_')[-1])
	else :
		adict[id] = line
ko_list_norepeat = list(set(ko_list))
for ko in ko_list_norepeat :
	for key in list(adict.keys()) :
		if key.split('_')[-1] == ko :
			print ('>' + key + '\n' + adict[key],file = open('tmp.fasta','a+'))
	os.system('cd-hit-est -i tmp.fasta -o tmp_result.fasta -c 0.9 -aS 0.9 -d 0 -n 9 -M 500000 -T 12')
	result = open('tmp_result.fasta','r').readlines()
	for x in result :
		x = x.strip()
		print (x,file = open('tblastn_cdhit.fasta','a+'))
	os.system('rm -rf tmp.fasta')
	os.system('rm -rf tmp_result.fasta')
	os.system('rm -rf tmp_result.fasta.clstr')