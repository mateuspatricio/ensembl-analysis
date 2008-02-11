#!/usr/local/bin/perl

# call 
#
# perl ./genebuild/prepare_proteome.pl 
#  -pmatch_output_file pmatch_output_file.fa 
#  -file_info protein_input_file='(\S+)' 
#
# use regex '/(\S+)/' if header format of your fasta is 
# >ABC234.1 
# >ABC234.1 
#

use strict;
use Bio::EnsEMBL::KillList::KillList;
use Bio::EnsEMBL::KillList::DBSQL::DBAdaptor;
use Bio::SeqIO;
use Bio::EnsEMBL::Utils::Exception qw(throw warning);
use Bio::EnsEMBL::Analysis::Tools::Logger qw (logger_info logger_verbosity);
use Getopt::Long;

my $output_file;
my @file_info;
my $skip_xs = 5;
my $use_killlist = 1;
my $skip_xps = 1;
my $logger_verbosity = "NONE";

&GetOptions(
            "proteome_file:s" => \$output_file,
            "file_info:s@" => \@file_info,
            "skip_xs:s" => \$skip_xs,
            "use_killlist!" => \$use_killlist,
            "logger_verbosity:s" => \$logger_verbosity,
           );

logger_verbosity($logger_verbosity);
my $kill_list_object = Bio::EnsEMBL::KillList::KillList->new(-TYPE => 'PROTEIN');
my %kill_list = %{$kill_list_object->get_kill_list()};

my %files;
my %refseq;
foreach my $file_info(@file_info){
  #print "Have file info ".$file_info."\n";
  my ($file, $regex, $other) = split /\=/, $file_info;
  #print "HAVE FILE ".$file." and regex ".$regex."\n";
  throw("Need both a file ".$file." and a regex ".$regex) if(!$file || !$regex);
  $files{$file} = $regex;
  if($other && $other =~ /^refseq$/i){
    $refseq{$file} = 1;
  }
}


if(-e $output_file){
  print "Protein file ".$output_file." already exists, these ".
    "entries will be appended to the end of the file\n";
  print "Do you want this? answer y/n or delete\n";
  my $reply = get_input_arg();
  if($reply =~ m/n/i){
    print "You must delete or rename ".$output_file." before you continue\n";
  }elsif($reply =~ m/delete/i){
    print "Running rm -f $output_file\n";
    system("rm -f $output_file"); 
    print "file $output_file deleted\n";
  }else{
    print "Will append new entries to ".$output_file."\n";
  }
}
my $output_io =  Bio::SeqIO->new(
                                 -format => 'fasta',
                                 -file   => ">>".$output_file,
                                );
my %ids;
foreach my $file(keys(%files)){
  my $refseq = $refseq{$file};
  my $regex = $files{$file};
  print "On file ".$file." with ".$regex."\n";
  my $x_string;
  if($skip_xs){
    $x_string = "X" x $skip_xs;
  }
  my $io =  Bio::SeqIO->new(
                            -format => 'fasta',
                            -file   => $file,
                           );
 SEQ:while(my $seq = $io->next_seq){
    my $parseable_string = $seq->id." ".$seq->desc;
    my ($id) = $parseable_string =~ /$regex/;
    if($id =~ m/^1$/){
      print "got ".$id." from ".$parseable_string."\n";
      die;
    } 
    if(!$id){
      warn($regex." failed to parse an id out of ".
            $parseable_string);
        next SEQ;
    }
    if($x_string){
      if($seq->seq =~ /$x_string/){
        logger_info($id." contains too many X characters, SKIPPING");
        next SEQ;
      }
    }
    if($refseq && !($id =~ /^NP/)){
      logger_info($id." isn't an NP so skipping");
      next SEQ;
    }
    my $no_version_id = $id;
    $no_version_id =~ s/\.\d+//;
    if($use_killlist && exists $kill_list{$no_version_id}){
      logger_info($id." on kill list as $no_version_id");
      next SEQ;
    }
    if($ids{$id}){
      logger_info($id." has already been stored");
      next SEQ;
    }
    $seq->desc("");
    $seq->id($id);
    my $seq_string = $seq->seq;
    $seq_string =~	s/U/X/g;
    $seq->seq($seq_string);
    $output_io->write_seq($seq);
  }
}

sub get_input_arg{
  my $line;
  print "Getting input arg\n";
  my $line = <>;
  return $line;
}
