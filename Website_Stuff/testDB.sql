drop database if exists TestSeqDB;

create database TestSeqDB;
use TestSeqDB;

create table Experimental (
	geneID varchar (20), 
    foldChange float,
    primary key (geneID));
    
insert into Experimental values
('HBA', +20), 
('APC', -5), 
('GAPDH', +2),
('OCA2', -3.7),
('COL1A1', +48),
('DMD', +1.2);

select * from Experimental;