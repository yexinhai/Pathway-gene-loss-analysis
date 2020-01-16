#!/usr/bin/perl -w
use strict;

#用法： perl find_pathway.pl <ko_ref.fasta> <blastp_result>

my $id;
my $ko_id;
my %hash_pathway;

open my $ko_ref, "<", $ARGV[0] or die "can't open ko_ref.fasta!\n";
while (<$ko_ref>) {
	chomp();
	if (/^>(\S+)\t(K\d+)\t.*/) {
		$id = $1;
		$ko_id = $2;
		$hash_pathway{$id} -> {koID} = $ko_id;
	} else {
		$hash_pathway{$id} -> {sequence} .= $_;
	}
}
close $ko_ref;

my @array_gene_name;
my %hash_blast_pair;

open my $blast, "<", $ARGV[1] or die "can't open blast file!\n";
while (<$blast>) {
	chomp();
	my @array = split /\t/, $_;
	$hash_blast_pair{$array[0]} = $array[1];
	push @array_gene_name, $array[1];
}
close $blast;

my @array_whole_ko;

foreach (@array_gene_name){
	push @array_whole_ko, $hash_pathway{$_} -> {koID};
}

my %count;
my @uniq_array_ko = grep { ++$count{$_} < 2; } @array_whole_ko;

open OUT1, ">", "ogs_have_ko.list";
foreach(@uniq_array_ko){
	print OUT1 $_."\n";
}
close OUT1;

my %hash_gene_ko;

foreach my $key (keys %hash_blast_pair) {
	my $ko = $hash_pathway{$hash_blast_pair{$key}} -> {koID};
	push @{$hash_gene_ko{$ko}}, $key;
}

open OUT2, ">", "ogs_have_gene_and_ko.txt";
foreach my $key (keys %hash_gene_ko) {
	my $value = join ("\t", @{$hash_gene_ko{$key}});
	print OUT2 $key."\t".$value."\n";
}
close OUT2;

my @array_all_ko_in_pathway;

foreach my $key (keys %hash_pathway) {
	push @array_all_ko_in_pathway, $hash_pathway{$key} -> {koID};
}

my %count1;
my @uniq_array_ko_all = grep { ++$count1{$_} < 2; } @array_all_ko_in_pathway;

#foreach (@uniq_array_ko_all) {
#	print $_."\n";
#}

my %hash_all_ko = map{$_ => 1} @uniq_array_ko_all;
my %hash_ko_in_ogs = map{$_ => 1} @uniq_array_ko;
my @array_ogs_donthave = grep {! $hash_ko_in_ogs{$_}} @uniq_array_ko_all;

#foreach (@array_ogs_donthave) {
#	print $_."\n";
#}

open OUT3, ">", "ogs_donthave_ko.list";
open OUT4, ">", "ogs_donthave_ko.fasta";
foreach (@array_ogs_donthave) {
	my $ko = $_;
	print OUT3 $ko."\n";
	foreach my $key (keys %hash_pathway) {
		if ($ko eq $hash_pathway{$key} -> {koID}) {
			print OUT4 ">".$key."\t".$ko."\n".$hash_pathway{$key} -> {sequence}."\n";
		}
	}
}
close OUT3;
close OUT4;

