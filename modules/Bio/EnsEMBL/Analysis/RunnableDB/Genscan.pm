# Ensembl module for Bio::EnsEMBL::Analysis::RunnableDB::Genscan
#
# Copyright (c) 2004 Ensembl
#

=head1 NAME

=head1 SYNOPSIS

  my $runnabledb = Bio::EnsEMBL::Analysis::RunnableDB::Genscan->
  new(
      -input_id => 'contig::AL805961.22.1.166258:1:166258:1',
      -db => $db,
      -analysis => $analysis,
     );
  $runnabledb->fetch_input;
  $runnabledb->run;
  $runnabledb->write_output;


=head1 DESCRIPTION



=head1 CONTACT

Post questions to the Ensembl development list: ensembl-dev@ebi.ac.uk

=cut

package Bio::EnsEMBL::Analysis::RunnableDB::Genscan;

use strict;
use warnings;

use Bio::EnsEMBL::Analysis::RunnableDB;
use Bio::EnsEMBL::Analysis::Runnable::Genscan;
use Bio::EnsEMBL::Analysis::Config::General;
use vars qw(@ISA);

@ISA = qw(Bio::EnsEMBL::Analysis::RunnableDB);


=head2 fetch_input

  Arg [1]   : Bio::EnsEMBL::Analysis::RunnableDB::Genscan
  Function  : fetch data out of database and create runnable
  Returntype: 1
  Exceptions: none
  Example   : 

=cut



sub fetch_input{
  my ($self) = @_;
  my $slice = $self->fetch_sequence($self->input_id, $self->db, 
                                    $ANALYSIS_REPEAT_MASKING);
  $self->query($slice);
  my %parameters;
  if($self->parameters_hash){
    %parameters = %{$self->parameters_hash};
  }
  my $runnable = Bio::EnsEMBL::Analysis::Runnable::Genscan->new
    (
     -query => $self->query,
     -program => $self->analysis->program_file,
     %parameters,
    );
  $self->runnable($runnable);
  return 1;
}




=head2 write_output

  Arg [1]   : Bio::EnsEMBL::Analysis::RunnableDB::Genscan
  Function  : writes the prediction transcripts back to the database
  after validation
  Returntype: none
  Exceptions: 
  Example   : 

=cut



sub write_output{
  my ($self) = @_;
  my $adaptor = $self->db->get_PredictionTranscriptAdaptor;
  my @output = @{$self->output};
  my $ff = $self->feature_factory;
  foreach my $pt(@output){
    $pt->analysis($self->analysis);
    $pt->slice($self->query) if(!$pt->slice);
    $ff->validate_prediction_transcript($pt, 1);
    $adaptor->store($pt);
  }
}
