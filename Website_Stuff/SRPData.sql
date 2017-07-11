drop database if exists SRPData;

create database SRPData;
use SRPData;

create table C_Rat1 (gene_name varchar(100), geneID varchar(100), gene_start int, gene_end int, FPKM float);
create table C_Rat2 (gene_name varchar(100), geneID varchar(100), gene_start int, gene_end int, FPKM float);
create table E_Rat1 (gene_name varchar(100), geneID varchar(100), gene_start int, gene_end int, FPKM float);
create table E_Rat2 (gene_name varchar(100), geneID varchar(100), gene_start int, gene_end int, FPKM float);
create table E_Rat3 (gene_name varchar(100), geneID varchar(100), gene_start int, gene_end int, FPKM float);