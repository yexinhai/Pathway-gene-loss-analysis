#!/usr/bin/perl -w
use strict;

my %hash_name2ko;

open my $ko_ref, "<", $ARGV[0] or die "can't open ko_ref.fasta!\n";
while (<$ko_ref>) {
	chomp();
	if (/^>(\S+:\S+)\t(\S+)\t.*/) {
		$hash_name2ko{$1} = $2; 
	}
}
close $ko_ref;

my @array_gene_name;
my %hash;
open my $blast, "<", $ARGV[1] or die "can't open blast file!\n";
while (<$blast>) {
	chomp();
	my @array = split /\t/, $_;
	$hash{$array[0]} = $array[1];
	push @array_gene_name, $array[1];
}
close $blast;

my @array_ko;

foreach (@array_gene_name){
	push @array_ko, $hash_name2ko{$_};
}


my %count;
my @uniq_array_ko = grep { ++$count{$_} < 2; } @array_ko;

#foreach(@uniq_array_ko){
#	print $_."\n";
#}

foreach my $key (keys %hash) {
	print $key."\t".$hash_name2ko{$hash{$key}}."\n";
}
