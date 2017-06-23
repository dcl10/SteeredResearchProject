#!/usr/bin/perl
use strict;
use warnings;

#script to automate pipeline 3
#use text file with list of samples and .fa file placed in same directory
#runs bwa with nice level 10 to prevent it hogging cpu

#check that a list file has been provided 
unless ($ARGV[0]){
  print "usage: pipe3.pl [file containing list of sample ids][reference.fa] \n";
  exit;
  
my $list_file = $ARGV[0];
my $ref_file = $ARGV[1];

#load needed modules;
system "module load bwa/0.7.15";
system "module load samtools/1.3.2";

#check if an indexed version of the ref exists
#If not, ask user if they want to creat an indexed version
my $index_check_bwt = $ref_file . ".bwt";
my $index_check_sa = $ref_file . ".sa";
my $index_check_ann = $ref_file . ".ann";
my $index_check_amb = $ref_file . ".amb";
unless (-e $index_check_bwt && -e $index_check_sa && -e $index_check_ann && -e $index_check_amb) {
 print "No indexed genome for $ref_file\n";
 print "Index $ref_file y/N - This may take a while";
 my $answer = <STDIN>;
 if ($answer eq "y"){
  system "bwa index $ref_file";
 }
 else{
  exit;
 }

#read through list of samples 
open (LIST, "$list_file") or die ("could not open $list_file \n");
while (my $sample <LIST>){
  chomp $sample;
  #make a directory for each sample
  system "mkdir $sample";
  
  #create a log file
  my $log_file = $sample . ".log";
  open (LOG, ">$log_file") or die (could not create $log_file);
  #print the terminal output of each system call to this file 
  
  #create file names
  my $read_1_fq = $sample . "_1.fq";
  my $read_2_fq = $sample . "_2.fq";
  #These files need to exist in local directory 
  #Add bit here to check they do
  my $read_1_sai = $sample . "/" . $sample . "_1.sai";
  my $read_2_sai = $sample . "/" . $sample . "_2.sai";
  my $sam_file = $sample . "/" . $sample . ".sam";

  #bwa backtrack
  #call bwa aln for each read file
  print "aln $read_1_fq";
  my $info = `nice -n 10 bwa aln -n 2 -l 25 -k 1 -t 4 $indexed $read_1_fq > $read_1_sai`;
  print LOG $info;
  print "aln $read_2_fq";
  $info = `nice -n 10 bwa aln -n 2 -l 25 -k 1 -t 4 $indexed $read_2_fq > $read_2_sai`;
  print LOG $info;
  
  #call bwa sampe
  print "sampe reads";
  $info = `nice -n 10 bwa sampe $indexed $read_1_sai $read_2_sai $read_1_fq $read_2_fq > $sam_file`;
  print LOG $info;
  
  #run samtools on output of bwa
  my $bam_file = $sample . "/" . $sample . ".bam";
  my $bam_sorted = $sample . "/" . $sample . "_sorted.bam";
  my $read_stats = $sample . "/" . $sample . "_stats.txt";
  
  #convert .sam to .bam
  print "convert $sam_file to .bam";
  $info = `samtools view -S -b $sam_file > $bam_file`;
  print LOG $info;
  
  #sort .bam file
  print "sort $bam_file";
  $info = `samtools sort $bam_file -o $bam_sorted`;
  print LOG $info;
  
  #last 2 samtools steps !!
  
}
close LIST;
