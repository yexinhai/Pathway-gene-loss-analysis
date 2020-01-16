#!/usr/bin/perl -w
#get_noblastko
use strict;

# yexinhai, yexinhai@zju.edu.cn

my @array_ko;
open my $ko_list, "<", $ARGV[0] or die "can't open ko_list!\n";
while (<$ko_list>) {
	chomp();
	my @array = split /\t/, $_;
	push  @array_ko, $array[1];
}
close $ko_list;

my @array_ko_all;
my %hash_ko;
my $ko;
my $id;
my $ann;
open my $all_ko, "<", $ARGV[1] or die "can't open kegg_db!\n";
while (<$all_ko>) {
	chomp();
	if (/^>(\S+:\S+\t\S+\t.*)/) {
		my %hash;
		my @array_1 = split /\t/,$1;
		push @array_ko_all, $array_1[1];
		$ko = $array_1[1];
		$id = $array_1[0];
		$ann = $array_1[2];
		push @{$hash_ko{$ko}}, \%hash;
	} else {
		$hash_ko{$ko} -> [-1] -> {"sequence"} .= $_;
		$hash_ko{$ko} -> [-1] -> {"id"} = $id;
		$hash_ko{$ko} -> [-1] -> {"ann"} = $ann;
	}
}
close $all_ko;

my %hash_a;
my %hash_b;
my %merge_all;
my @b_only;
%hash_a = map{$_=>1} @array_ko;
%hash_b = map{$_=>1} @array_ko_all;
%merge_all = map {$_=>1} @array_ko,@array_ko_all;
@b_only = grep {!$hash_a{$_}} @array_ko_all;

my %count;
my @uniq_noblastko = grep { ++$count{$_} < 2; } @b_only;

foreach (@uniq_noblastko) {
	my $a = $_;
	foreach (@{$hash_ko{$a}}) {
		print ">".$_ -> {"id"}."\t".$a."\t".$_ -> {"ann"}."\n".$_ -> {"sequence"}."\n";
	}
}
