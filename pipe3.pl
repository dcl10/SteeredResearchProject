#!/usr/bin/perl
use strict;
use warnings;

#script to automate pipeline 3
#use text file with list of samples and .fa file placed in same directory

#check that a list file has been provided 
unless ($ARGV[0]){
  print "usage: pipe3.pl [file containing list of sample ids][reference.fa] \n";
  exit;
  
my $list_file = $ARGV[0];
my $ref_file = $ARGV[1];

#load needed modules;
system "module load bwa/0.7.15";
system "module load samtools/1.3.2";

#check if an idex version of the ref exists
#if not create 1
my $indexed;

#read through list of samples 
open (LIST, "$list_file") or die ("could not open $list_file \n");
while (<LIST>){
  chomp $_;
  #make a directory for each sample
  system "mkdir $_";
  
  #create a log file 
  
  #create file names
  my $read_1_fq = $_ . "_1.fq";
  my $read_2_fq = $_ . "_2.fq";
  #These files need to exist in local directory 
  #Add bit here to check they do
  my $read_1_sai = $_ . "/" . $_ . "_1.sai";
  my $read_2_sai = $_ . "/" . $_ . "_2.sai";
  my $sam_file = $_ . "/" . $_ . ".sam";

  #call bwa aln for each read file 
  system "bwa aln -n 2 -l 25 -k 1 -t 4 $indexed $read_1_fq > $read_1_sai";
  system "bwa aln -n 2 -l 25 -k 1 -t 4 $indexed $read_2_fq > $read_2_sai";
  
  #call bwa sampe
  system "bwa sampe $indexed $read_1_sai $read_2_sai $read_1_fq $read_2_fq > $sam_file";
  
  #run samtools on output of bwa
  my $bam_file = $_ . "/" . $_ . ".bam";
  my $bam_sorted = $_ . "/" . $_ . "_sorted.bam";
  my $read_stats = $_ . "/" . $_ . "_stats.txt";
  
  #convert .sam to .bam
  system "samtools view -S -b $sam_file > $bam_file";
  
  #sort .bam file
  system "samtools sort $bam_file -o $bam_sorted";
  
  #get statistics
  system "samtools stats $bam_sorted > $read_stats";
  
}
close LIST;
