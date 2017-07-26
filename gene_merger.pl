#!/usr/bin/perl
use strict; use warnings;
#Takes a gene.fpkm.tracking file produced by cufflinks and merges the information for genes which share the same gene short name annotation, as well as ensuring 
#each gene has only a single short name annotation.
#
#Change log:
#20/07/17 RG: Modified to generate names for output file based on input filename.
#
#Created by R. Gosliga 14/07/2017.

my %genes; my %gene_count; my $gen_id = 1;
open(INPUT, "<$ARGV[0]") or die ("Unable to open $ARGV[0]");

#Removes the path from the input file and stores it for naming output files.
$ARGV[0] =~s/.*?\/([^\/]*)\.([^\/]*)$/$1/i;

open(OUTPUT, ">unique_$ARGV[0].out") or die("Can't open unique_$ARGV[0].out");
print OUTPUT "tracking_id\tclass_code\tnearest_ref_id\tgene_id\tgene_short_name\ttss_id\tlocus\tlength\tcoverage\tFPKM\tFPKM_conf_lo\tFPKM_conf_hi\tFPKM_status\n";

foreach (<INPUT>) {
	#Identifies the following columns in each capture group: Tuxedo Tracking ID, Gene Short Name (Single), any additional short names (discarded), TSS IDs, locus, FPKM, FPKM confidence low, FPKM confidence high.
	$_ =~/^(\S*)\t\S*\t\S*\t\S*\t(\S*?)(,\S*)*\t(\S*)\t(\S*)\t\S*\t\S*\t(\S*)\t(\S*)\t(\S*)/;
	#Executes if gene is already in hash, indicating that merging is required.
	if (exists($genes{$2})) {
		my $gene_name = $2; my $locus = $5;
		$gene_count{$gene_name}++;
		#Assigns earlier capture groups into hash of arrays, with the short name serving as the key of the hash. Locus is not added due to further processing being required.
		${$genes{$gene_name}}[0] .= ",$1";
		${$genes{$gene_name}}[1] .= ",$4";
		${$genes{$gene_name}}[3] += $6;
		${$genes{$gene_name}}[4] += $7;
		${$genes{$gene_name}}[5] += $8;
		#Determines which locus starts earlier and ends later, using the earliest start and latest end for the final locus.
		$locus =~/\w*:(\d*)-(\d*)/;
		my $min = $1; my $max = $2;
		${$genes{$gene_name}}[2] =~/(\w*):(\d*)-(\d*)/;
		if ($min > $2) {$min = $2};
		if ($max > $3) {$max = $3};
		${$genes{$gene_name}}[2] = "$1:$min-$max";
	#Automatically generates unique IDs for genes lacking a short name.
	} elsif ($2 eq "-") {
	print OUTPUT "$1\t-\t-\t$1\tUnknown$gen_id\t$4\t$5\t-\t-\t$6\t$7\t$8\tOK\n";
	$gen_id++;
	#Adds the gene into the hash using the short name as a key.
	} elsif ($2=~/gene_short_name/) {
	} else {
		@{$genes{$2}} = ($1, $4, $5, $6, $7, $8);
		$gene_count{$2} = 1;
		}
	}
close(INPUT);

#Prints out the hash with the same formatting as the original fpkm_tracking file. Many values are assumed due to them either being largely absent anyway or being determined to be unimportant (e.g. length can be derived).
foreach (keys(%genes)) {
	print OUTPUT "${$genes{$_}}[0]\t-\t-\t${$genes{$_}}[0]\t$_\t${$genes{$_}}[1]\t${$genes{$_}}[2]\t-\t-\t${$genes{$_}}[3]\t${$genes{$_}}[4]\t${$genes{$_}}[5]\tOK\n";
	}
close(OUTPUT);

#Calculates the mean number of times each gene is merged, and what the maximum number of times a gene is merged is.
open(OUTSTATS, ">$ARGV[0]\_stats.txt");
my $max = 1; my $total; my $mean; my $count; my $merge_count;
foreach (keys(%gene_count)) {
		$count++;
		if ($gene_count{$_} > $max) {$max = $gene_count{$_}};
		if ($gene_count{$_} > 1) {$merge_count++;}
		$total += $gene_count{$_};
		}
$mean = $total / $count;
my $var_total; my $stand_dev;

#Calculates the standard deviation. Requires a seperate loop as the final mean has to be calculated prior.
foreach (keys(%gene_count)) {$var_total += ($gene_count{$_} - $mean)**2;}
$stand_dev = $var_total / $count;
print OUTSTATS ("The maximum number of genes merged into one is: $max, the average number of genes merged into one is: $mean, the standard deviation is: $stand_dev, the number of gene names which had a merge is: $merge_count out of $count");
close(OUTSTATS);
