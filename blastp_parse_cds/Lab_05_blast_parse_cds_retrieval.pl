#! /usr/bin/perl

use warnings;
use strict;

use Bio::DB::Fasta;
use Bio::PrimarySeq;

# Any new module should be incorporated into your program by a use function.

my $pep_db=Bio::DB::Fasta->new("../proteome_databases/at_pep.fa");
my $cds_db=Bio::DB::Fasta->new("../transcriptomes/at_cds.fa");

open BLAST_PARSE,"<../blastp_parse_results/Lab_03_blast_parse_out.txt";

while(my $parse_id=<BLAST_PARSE>){

		chomp $parse_id;

		my $pep_obj=$pep_db->get_Seq_by_id($parse_id);
		my $pep=$pep_obj->seq;

		my $cds_obj=$cds_db->get_Seq_by_id($parse_id);
		my $cds=$cds_obj->seq;

# Similar to retrieving a protein sequence, we use Bio::DB::Fasta to get a CDS for a target hit.
		
 		my $translate_obj=Bio::PrimarySeq->new(
                         		 -seq=>$cds
						);

# This is a typical structure to setup an objective in OO programming.  You may just remember this structure for how to setup an objective for Bio::PrimarySeq module

		my $translate_pep=$translate_obj->translate->seq();

# Another OO programming for introducing two methods, translate and seq, to get a translated peptide sequence from a CDS.

		$pep=~s/\*//g;
		$translate_pep=~s/\*//g;
# remove stop codons; Some databases do not add stop codon(s) in a peptide sequence

		die $parse_id,"\n",$pep,"\n",$translate_pep,"\n", unless($pep eq $translate_pep);

# Here, we introduced three Perl syntaxes.  As the name states, die means terminate the program.  However, it also has a similar function to print.  In this statement, it will print out $parse_id if $pep is not the same as $translate_pep.  In other word, it will not stop and print out $parse_id if $pep is the same (eq) as $translate_pep.  This is the proofread function often used in programming.
		
		print ">",$parse_id,"\n";
	    	print  $cds,"\n";

# print out the CDS if $cds passes the proof.

 }
		
	close BLAST_PARSE;

# After finish reading the file, the file should be closed. 

	exit;

