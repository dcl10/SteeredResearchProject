#!/usr/bin/perl
use strict; use warnings;
#Takes a gene.fpkm.tracking file produced by cufflinks and merges the information for genes which share the same gene short name annotation, as well as ensuring each gene has only a single short name annotation.

my %genes; my %gene_count;
open(INPUT, "<$ARGV[0]") or die ("NO! I'M NOT READY!");
foreach (<INPUT>) {
	$_ =~/^(\S*)\t\S*\t\S*\t\S*\t(\S*?)((,)\S*)*\t(\S*)\t(\S*)\t\S*\t\S*\t(\S*)\t(\S*)\t(\S*)/;
	if (exists($genes{$2})) {
		my $gene_name = $2; my $locus = $6;
		$gene_count{$gene_name}++;
		${$genes{$gene_name}}[0] .= ",$1";
		${$genes{$gene_name}}[1] .= ",$5";
		${$genes{$gene_name}}[3] += $7;
		${$genes{$gene_name}}[4] += $8;
		${$genes{$gene_name}}[5] += $9;
		$locus =~/\w*:(\d*)-(\d*)/;
		my $min = $1; my $max = $2;
		${$genes{$gene_name}}[2] =~/(\w*):(\d*)-(\d*)/;
		if ($min > $2) {$min = $2};
		if ($max > $3) {$max = $3};
		${$genes{$gene_name}}[2] = "$1:$min-$max";
	} elsif ($2 eq "-") {
	} else {
		@{$genes{$2}} = ($1, $5, $6, $7, $8, $9);
		$gene_count{$2} = 1;
		}
	}
close(INPUT);
open(OUTPUT, ">unique_genes.gtf");
foreach (keys(%genes)) {
	print OUTPUT "${$genes{$_}}[0]\t-\t-\t${$genes{$_}}[0]\t$_\t${$genes{$_}}[1]\t${$genes{$_}}[2]\t-\t-\t${$genes{$_}}[3]\t${$genes{$_}}[4]\t${$genes{$_}}[5]\tOK\n";
	}
close(OUTPUT);
open(OUTSTATS, ">gene_merger_stats.txt");
my $max = 1; my $total; my $mean; my $count;
foreach (keys(%gene_count)) {
		$count++;
		if ($gene_count{$_} > $max) {$max = $gene_count{$_}};
		$total += $gene_count{$_};
		}
$mean = $total / $count;
my $var_total; my $stand_dev;
foreach (keys(%gene_count)) {$var_total += ($gene_count{$_} - $mean)**2;}
$stand_dev = $var_total / $count;

print OUTSTATS ("The maximum number of genes merged into one is: $max, the average number of genes merged into one is: $mean, the standard deviation is: $stand_dev");
