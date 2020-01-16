#! /bin/bash
# yangyi, yylqy@zju.edu.cn;

cd /lab/yangyi/project/10_amino_acid_pathway/add_spec20200116/01_data/
makeblastdb -in Biosynthesis_of_amino_acids_ko_new.fasta -out Biosynthesis_of_amino_acids_ko -dbtype prot

while read line
do	
	cd /lab/yangyi/project/10_amino_acid_pathway/add_spec20200116
	mkdir ${line}
	cd /lab/yangyi/project/10_amino_acid_pathway/add_spec20200116/${line}
	blastp -query /lab/yangyi/project/10_amino_acid_pathway/add_spec20200116/01_data/${line}_protein.fasta -num_alignments 1 -num_threads 12 -db /lab/yangyi/project/10_amino_acid_pathway/add_spec20200116/01_data/Biosynthesis_of_amino_acids_ko -out ${line}.blastp -evalue 1e-3 -outfmt '6 std qlen slen qcovs'
	perl /lab/yangyi/project/10_amino_acid_pathway/add_spec20200116/02_script/find_pathway_ko.pl /lab/yangyi/project/10_amino_acid_pathway/add_spec20200116/01_data/Biosynthesis_of_amino_acids_ko_new.fasta ${line}.blastp
	makeblastdb -in /lab/yangyi/project/10_amino_acid_pathway/add_spec20200116/01_data/${line}_genome.fasta -out ${line}.genome -dbtype nucl
	tblastn -query ogs_donthave_ko.fasta -num_threads 12 -db ${line}.genome -out ${line}_ogs_donthave.tblastn -evalue 1e-5 -outfmt '6 std qlen slen qcovs'
	perl /lab/yangyi/project/10_amino_acid_pathway/add_spec20200116/02_script/how_many_ko2.pl /lab/yangyi/project/10_amino_acid_pathway/add_spec20200116/01_data/Biosynthesis_of_amino_acids_ko_new.fasta ${line}_ogs_donthave.tblastn >${line}_tblastn_haveko.list
	python /lab/yangyi/project/10_amino_acid_pathway/dall20200111/get_tblastn_seq.py /lab/yangyi/project/10_amino_acid_pathway/add_spec20200116/01_data/Biosynthesis_of_amino_acids_ko_new.fasta /lab/yangyi/project/10_amino_acid_pathway/add_spec20200116/01_data/${line}_genome.fasta ${line}_ogs_donthave.tblastn >tblastn_all_ko.fasta
	python /lab/yangyi/project/10_amino_acid_pathway/dall20200111/method3_cdhit.py
	cd ~
done </lab/yangyi/project/10_amino_acid_pathway/add_spec20200116/02_script/list.txt
