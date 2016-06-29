=head1 LICENSE

Copyright [1999-2016] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

package Mouse_strain_loading_conf;

use strict;
use warnings;

use base ('Bio::EnsEMBL::Hive::PipeConfig::HiveGeneric_conf');
use Bio::EnsEMBL::ApiVersion qw/software_version/;

sub default_options {
    my ($self) = @_;
    return {
        # inherit other stuff from the base class
        %{ $self->SUPER::default_options() },

######################################################
#
# Variable settings- You change these!!!
#
######################################################

########################
# Misc setup info
########################
'strain'               => '129S1_SvImJ_v1',
'farm_user_name'       => 'mpg_pr', # for ref db prefix
'genebuilder_id'       => '40', # for meta table
'enscode_root_dir'     => '/nfs/users/nfs_f/fm2/enscode/', # git repo checkouts
'repeatmasker_library' => 'mouse', # repbase library to use
'species_name'         => 'mus_musculus',
'taxon_id'             => '10090',
'repeatmasker_engine'  => 'crossmatch',
'email_address'        => 'rishi@ebi.ac.uk',


########################
# Pipe and ref db info
########################

'pipe_db_server'                 => 'genebuild3', # NOTE! used to generate tokens in the resource_classes sub below
'reference_db_server'            => 'genebuild4', # NOTE! used to generate tokens in the resource_classes sub below

'user_r'                         => 'ensro',
'user_w'                         => 'ensadmin',
'password'                       => '',
'port'                           => '3306',


'output_path'               => '/lustre/scratch109/ensembl/rn6/mouse_strains_1/mus_musculus/129S1_SvImJ_v1/',
'primary_assembly_dir_name' => 'Primary_Assembly',
'wgs_id'                    => 'LVXH',
'assembly_name'             => '129S1_SvImJ_v1',
'assembly_accession'        => 'GCA_001624185.1',
'full_ftp_path'             => 'ftp://ftp.ncbi.nlm.nih.gov/genomes/genbank/vertebrate_mammalian/Mus_musculus/all_assembly_versions/GCA_001624185.1_129S1_SvImJ_v1//GCA_001624185.1_129S1_SvImJ_v1_assembly_structure',
'chromosomes_present'       => '1',


########################
# BLAST db paths
########################
'uniprot_blast_db_path'     => '/data/blastdb/Ensembl/uniprot_2016_04/uniprot_vertebrata',
'uniprot_index'             => '/data/blastdb/Ensembl/uniprot_2016_04/entry_loc',
'vertrna_blast_db_path'     => '/data/blastdb/Ensembl/vertrna_xdformat_2016_04/embl_vertrna-1',
'unigene_blast_db_path'     => '/data/blastdb/Ensembl/unigene/unigene',
#'mito_index_path'           => '/data/blastdb/Ensembl/refseq_mitochondria_set/mito_index.txt',

# Annotation loading
'gtf_parsing_script'        => '/nfs/users/nfs_f/fm2/enscode/ensembl-personal/fm2/scripts/load_gtf_ensembl.pl',
'loading_report_script'     => '/nfs/users/nfs_f/fm2/enscode/ensembl-personal/fm2/scripts/report_genome_prep_stats.pl',

######################################################
#
# Mostly constant settings
#
######################################################

'pipeline_name'                  => $self->o('farm_user_name').'_'.$self->o('species_name').'_'.$self->o('strain').'_pipe',

'min_toplevel_slice_length'   => 0,

'repeat_logic_names'          => ['repeatmasker_repbase_'.$self->o('repeatmasker_library'),'dust'],
'homology_models_path'        => $self->o('output_path').'/homology_models',
'clone_db_script_path'        => $self->o('enscode_root_dir').'/ensembl-analysis/scripts/clone_database.ksh',

########################
# Extra db settings
########################

'driver' => 'mysql',
'num_tokens' => 10,

########################
# Executable paths
########################
'dust_path' => '/software/ensembl/genebuild/usrlocalensemblbin/tcdust',
'trf_path' => '/software/ensembl/genebuild/usrlocalensemblbin/trf',
'eponine_path' => '/software/jdk1.6.0_14/bin/java',
'firstef_path' => '/software/ensembl/genebuild/usrlocalensemblbin/firstef',
'cpg_path' => '/software/ensembl/genebuild/usrlocalensemblbin/cpg',
'trnascan_path' => '/software/ensembl/genebuild/usrlocalensemblbin/tRNAscan-SE',
'repeatmasker_path' => '/software/ensembl/bin/RepeatMasker_4_0_5/RepeatMasker',
'genscan_path' => '/software/ensembl/genebuild/usrlocalensemblbin/genscan',
'uniprot_blast_exe_path' => '/software/ensembl/genebuild/usrlocalensemblbin/wublastp',
'vertrna_blast_exe_path' => '/software/ensembl/genebuild/usrlocalensemblbin/wutblastn',
'unigene_blast_exe_path' => '/software/ensembl/genebuild/usrlocalensemblbin/wutblastn',


########################
# Misc setup info
########################
'contigs_source' => 'ncbi',
'primary_assembly_dir_name' => 'Primary_Assembly',

########################
# db info
########################
'user' => 'ensro',


'pipeline_db' => {
  -dbname => $self->o('farm_user_name').'_'.$self->o('species_name').'_'.$self->o('strain').'_pipe',
  -host   => $self->o('pipe_db_server'),
  -port   => $self->o('port'),
  -user   => $self->o('user_w'),
  -pass   => $self->o('password'),
  -driver => $self->o('driver'),
},

# NOTE! the dbname for each species is generated in the pipeline itself by setup_assembly_loading_pipeline
'reference_db' => {
  -dbname => $self->o('farm_user_name').'_'.$self->o('species_name').'_'.$self->o('strain').'_core',
  -host   => $self->o('reference_db_server'),
  -port   => $self->o('port'),
  -user   => $self->o('user_w'),
  -pass   => $self->o('password'),
},


'production_db' => {
  -host   => 'ens-staging1',
  -port   => 3306,
  -user   => 'ensro',
  -dbname => 'ensembl_production',
},

'taxonomy_db' => {
  -host   => 'ens-livemirror',
  -port   => 3306,
  -user   => 'ensro',
  -dbname => 'ncbi_taxonomy',
},


    };
}

sub pipeline_create_commands {
    my ($self) = @_;
    return [
    # inheriting database and hive tables' creation
      @{$self->SUPER::pipeline_create_commands},

    ];
}


## See diagram for pipeline structure
sub pipeline_analyses {
    my ($self) = @_;

    return [


###############################################################################
#
# ASSEMBLY LOADING ANALYSES
#
###############################################################################

      {
        # Download the files and dir structure from the NCBI ftp site. Uses the link to a species in the ftp_link_file
        -logic_name => 'download_assembly_info',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveDownloadNCBIFtpFiles',
        -parameters => {
                         'full_ftp_path'             => $self->o('full_ftp_path'),
                         'output_path'               => $self->o('output_path'),
                         'primary_assembly_dir_name' => $self->o('primary_assembly_dir_name'),
                       },
        -rc_name    => 'default',
        -flow_into  => {
                         1 => ['find_contig_accessions'],
                       },
        -input_ids  => [{}],
      },

      {
        # Get the prefixes for all contigs from the AGP files
        -logic_name => 'find_contig_accessions',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveFindContigAccessions',
        -parameters => {
                         'contigs_source'            => $self->o('contigs_source'),
                         'wgs_id'                    => $self->o('wgs_id'),
                         'output_path'               => $self->o('output_path'),
                         'primary_assembly_dir_name' => $self->o('primary_assembly_dir_name'),
                       },
        -rc_name    => 'default',
        -flow_into  => {
                         1 => ['download_contigs'],
                       },
      },

      {
        # Download contig from NCBI
        -logic_name => 'download_contigs',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveDownloadContigs',
        -parameters => {
                         'contigs_source'            => $self->o('contigs_source'),
                         'wgs_id'                    => $self->o('wgs_id'),
                         'output_path'               => $self->o('output_path'),
                         'primary_assembly_dir_name' => $self->o('primary_assembly_dir_name'),
                       },
        -rc_name    => 'default',
        -flow_into  => {
                         1 => ['populate_production_tables'],
                       },
      },

      {
        # Creates a reference db for each species
        -logic_name => 'create_core_db',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveCreateDatabase',
        -parameters => {
                         'target_db'        => $self->o('reference_db'),
                         'user_w'           => $self->o('user_w'),
                         'pass_w'           => $self->o('password'),
                         'enscode_root_dir' => $self->o('enscode_root_dir'),
                         'create_type'      => 'core_only',
                       },
        -rc_name    => 'default',
        -input_ids => [{}],

      },

      {
        # Load production tables into each reference
        -logic_name => 'populate_production_tables',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HivePopulateProductionTables',
        -parameters => {
                         'target_db'        => $self->o('reference_db'),
                         'output_path'      => $self->o('output_path'),
                         'enscode_root_dir' => $self->o('enscode_root_dir'),
                         'production_db'    => $self->o('production_db'),
                       },
        -rc_name    => 'default',
        -flow_into  => {
                         1 => ['load_contigs'],
                       },
         -wait_for => ['create_core_db'],
      },

      {
        # Load the contigs into each reference db
        -logic_name => 'load_contigs',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveLoadSeqRegions',
        -parameters => {
                         'coord_system_version'      => $self->o('assembly_name'),
                         'target_db'                 => $self->o('reference_db'),
                         'output_path'               => $self->o('output_path'),
                         'enscode_root_dir'          => $self->o('enscode_root_dir'),
                         'primary_assembly_dir_name' => $self->o('primary_assembly_dir_name'),
                       },
        -rc_name    => 'default',
        -flow_into  => {
                         1 => ['load_assembly_info'],
                       },
      },

      {
        # Load the AGP files
        -logic_name => 'load_assembly_info',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveLoadAssembly',
        -parameters => {
                         'target_db'                 => $self->o('reference_db'),
                         'output_path'               => $self->o('output_path'),
                         'enscode_root_dir'          => $self->o('enscode_root_dir'),
                         'primary_assembly_dir_name' => $self->o('primary_assembly_dir_name'),
                       },

        -rc_name    => 'default',
        -flow_into  => {
                         1 => ['set_toplevel'],
                       },
      },


      {
        # Set the toplevel
        -logic_name => 'set_toplevel',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveSetAndCheckToplevel',
        -parameters => {
                         'target_db'            => $self->o('reference_db'),
                         'output_path'          => $self->o('output_path'),
                         'enscode_root_dir'     => $self->o('enscode_root_dir'),
                         'primary_assembly_dir_name' => $self->o('primary_assembly_dir_name'),
                       },
        -rc_name    => 'default',
        -flow_into  => {
                         1 => ['load_meta_info'],
                       },
      },


      {
        # Load some meta info and seq_region_synonyms
        -logic_name => 'load_meta_info',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveSetMetaAndSeqRegionSynonym',
        -parameters => {
                         'taxon_id'                  => $self->o('taxon_id'),
                         'chromosomes_present'       => $self->o('chromosomes_present'),
                         'genebuilder_id'            => $self->o('genebuilder_id'),
                         'target_db'                 => $self->o('reference_db'),
                         'output_path'               => $self->o('output_path'),
                         'enscode_root_dir'          => $self->o('enscode_root_dir'),
                         'primary_assembly_dir_name' => $self->o('primary_assembly_dir_name'),
                       },
        -rc_name    => 'default',
        -flow_into  => {
                          1 => ['load_taxonomy_info'],
                       },
      },

      {
        -logic_name => 'load_taxonomy_info',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveLoadTaxonomyInfo',
        -parameters => {
                         'target_db'        => $self->o('reference_db'),
                         'enscode_root_dir' => $self->o('enscode_root_dir'),
                       },
        -rc_name    => 'default',
        -flow_into => {
                        # FirstEF is left out here as it runs on repeats. Repeatmasker analyses flow into it
                        '1->A' => ['create_1mb_slice_ids'],
                        'A->1' => ['backup_core_db'],
                      },

#        -flow_into  => {
#                          1 => ['create_1mb_slice_ids'],
#                       },
      },


#      {
#        # Load the AGP files
#        -logic_name => 'load_mitochondrion',
#        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveLoadMitochondrion',
#        -parameters => {
#                         'target_db'                 => $self->o('reference_db'),
#                         'output_path'               => $self->o('output_path'),
#                         'enscode_root_dir'          => $self->o('enscode_root_dir'),
#                         'mito_index_path'           => $self->o('mito_index_path'),
#                         'species_name'              => $self->o('species_name'),
#                         'chromosomes_present'       => $self->o('chromosomes_present'),
#                      },
#        -rc_name    => 'default',
#        -flow_into  => {
#                         1 => ['create_1mb_slice_ids'],
#                       },
#      },


      {
        # Create 1mb toplevel slices, each species flow into this independantly
        -logic_name => 'create_1mb_slice_ids',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveSubmitAnalysis',
        -parameters => {
                         target_db        => $self->o('reference_db'),
                         coord_system_name => 'toplevel',
                         slice => 1,
                         slice_size => 1000000,
                         include_non_reference => 0,
                         top_level => 1,
                         min_slice_length => $self->o('min_toplevel_slice_length'),
                       },
        -flow_into => {
                        '4' => ['run_repeatmasker'],
                      },

      },


###############################################################################
#
# REPEATMASKER ANALYSES
#
###############################################################################

      {
        -logic_name => 'run_repeatmasker',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveRepeatMasker',
        -parameters => {
                         target_db => $self->o('reference_db'),
                         logic_name => 'repeatmasker_repbase_'.$self->o('repeatmasker_library'),
                         module => 'HiveRepeatMasker',
                         repeatmasker_path => $self->o('repeatmasker_path'),
                         commandline_params => '-nolow -species "'.$self->o('repeatmasker_library').'" -engine "'.$self->o('repeatmasker_engine').'"',
                       },
        -rc_name    => 'repeatmasker',
        -flow_into => {
                        -1 => ['run_repeatmasker_himem'],
                        4 => ['run_dust'],
                      },
        -hive_capacity => 900,
      },

      {
        -logic_name => 'run_repeatmasker_himem',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveRepeatMasker',
        -parameters => {
                         target_db => $self->o('reference_db'),
                         logic_name => 'repeatmasker_repbase_'.$self->o('repeatmasker_library'),
                         module => 'HiveRepeatMasker',
                         repeatmasker_path => $self->o('repeatmasker_path'),
                         commandline_params => '-nolow -species "'.$self->o('repeatmasker_library').'" -engine "'.$self->o('repeatmasker_engine').'"',
                       },
        -rc_name    => 'repeatmasker_himem',
        -flow_into => {
                         4 => ['run_dust'],
                      },
        -hive_capacity => 900,
        -can_be_empty  => 1,
      },


      {
        # Set the toplevel
        -logic_name => 'dump_softmasked_toplevel',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveDumpGenome',
        -parameters => {
                         'coord_system_name'    => 'toplevel',
                         'target_db'            => $self->o('reference_db'),
                         'output_path'          => $self->o('output_path')."/genome_dumps/",
                         'enscode_root_dir'     => $self->o('enscode_root_dir'),
                         'species_name'         => $self->o('species_name')."_".$self->o('strain'),
                         'repeat_logic_names'   => $self->o('repeat_logic_names'),
                       },
        -input_ids => [{}],
        -wait_for => ['run_dust','run_repeatmasker','run_repeatmasker_himem'],
        -rc_name    => 'default',
      },

###############################################################################
#
# SIMPLE FEATURE AND OTHER REPEAT ANALYSES
#
###############################################################################

      {
        # Run dust
        -logic_name => 'run_dust',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveDust',
        -parameters => {
                         target_db => $self->o('reference_db'),
                         logic_name => 'dust',
                         module => 'HiveDust',
                         dust_path => $self->o('dust_path'),
                       },
        -rc_name    => 'simple_features',
        -flow_into => {
                         4 => ['run_trf'],
                      },
        -hive_capacity => 900,
        -batch_size => 20,
      },

      {
        # Run TRF
        -logic_name => 'run_trf',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveTRF',
        -parameters => {
                         target_db => $self->o('reference_db'),
                         logic_name => 'trf',
                         module => 'HiveTRF',
                         trf_path => $self->o('trf_path'),
                       },
        -rc_name    => 'simple_features',
        -flow_into => {
                         4 => ['run_eponine'],
                      },
       -hive_capacity => 900,
       -batch_size => 20,
      },

      {
        # Run eponine
        -logic_name => 'run_eponine',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveEponine',
        -parameters => {
                         target_db => $self->o('reference_db'),
                         logic_name => 'eponine',
                         module => 'HiveEponine',
                         eponine_path => $self->o('eponine_path'),
                         commandline_params => '-epojar=> /software/ensembl/genebuild/usrlocalensembllib/eponine-scan.jar, -threshold=> 0.999',
                       },
        -rc_name    => 'simple_features',
        -flow_into => {
                         4 => ['run_firstef'],
                      },
       -hive_capacity => 900,
       -batch_size => 20,
      },

      {
        # Run FirstEF. This differs slightly from the other in that it uses repeatmasking so in pipeline terms
        # it is set to run after repeatmasker instead of in parallel, unlike the others
        -logic_name => 'run_firstef',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveFirstEF',
        -parameters => {
                         target_db => $self->o('reference_db'),
                         logic_name => 'firstef',
                         module => 'HiveFirstEF',
                         firstef_path => $self->o('firstef_path'),
                         repeat_masking_logic_names => ['repeatmasker_repbase_'.$self->o('repeatmasker_library')],
                         commandline_params => '-repeatmasked',
                       },
        -rc_name    => 'simple_features',
        -flow_into => {
                         4 => ['run_cpg'],
                      },
       -hive_capacity => 900,
       -batch_size => 20,
      },

      {
        # Run CPG
        -logic_name => 'run_cpg',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveCPG',
        -parameters => {
                         target_db => $self->o('reference_db'),
                         logic_name => 'cpg',
                         module => 'HiveCPG',
                         cpg_path => $self->o('cpg_path'),
                       },
        -rc_name    => 'simple_features',
        -flow_into => {
                        4 => ['run_trnascan'],
                      },
       -hive_capacity => 900,
       -batch_size => 20,
      },

      {
        # Run tRNAscan
        -logic_name => 'run_trnascan',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveTRNAScan',
        -parameters => {
                         target_db => $self->o('reference_db'),
                         logic_name => 'trnascan',
                         module => 'HiveTRNAScan',
                         trnascan_path => $self->o('trnascan_path'),
                       },
        -rc_name    => 'simple_features',
        -flow_into => {
                         4 => ['run_genscan'],
                      },
       -hive_capacity => 900,
       -batch_size => 20,
      },


###############################################################################
#
# GENSCAN ANALYSIS
#
##############################################################################

      {
        # Run genscan, uses 1mb slices from repeatmasker. Flows into create_prediction_transcript_ids which
        # then takes these 1mb slices and converts them into individual prediction transcript input ids based
        # on the dbID of each feature generate by this analysis
        -logic_name => 'run_genscan',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveGenscan',
        -parameters => {
                         target_db => $self->o('reference_db'),
                         logic_name => 'genscan',
                         module => 'HiveGenscan',
                         genscan_path => $self->o('genscan_path'),
                         repeat_masking_logic_names => ['repeatmasker_repbase_'.$self->o('repeatmasker_library')],
                       },
        -rc_name    => 'genscan',
        -flow_into => {
                        4 => ['create_prediction_transcript_ids'],
                        -1 => ['decrease_genscan_slice_size'],
                        -2 => ['decrease_genscan_slice_size'],
                      },
       -hive_capacity => 900,
       -batch_size => 20,
      },



      {
        # Create 1mb toplevel slices, each species flow into this independantly
        -logic_name => 'decrease_genscan_slice_size',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveSubmitAnalysis',
        -parameters => {
                         split_slice => 1,
                         slice_size => 100000,
                       },
        -flow_into => {
                        4 => ['run_genscan_short_slice'],
                      },
        -rc_name    => 'default',
        -can_be_empty  => 1,
      },

      {
        -logic_name => 'run_genscan_short_slice',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveGenscan',
        -parameters => {
                         target_db => $self->o('reference_db'),
                         logic_name => 'genscan',
                         module => 'HiveGenscan',
                         genscan_path => $self->o('genscan_path'),
                         repeat_masking_logic_names => ['repeatmasker_repbase_'.$self->o('repeatmasker_library')],
                       },
        -rc_name    => 'genscan',
        -flow_into => {
                        4 => ['create_prediction_transcript_ids'],
                        -1 => ['failed_genscan_slices'],
                        -2 => ['failed_genscan_slices'],
                      },
        -rc_name    => 'genscan_short',
        -can_be_empty  => 1,
        -hive_capacity => 900,
      },


      {
        -logic_name => 'failed_genscan_slices',
        -module     => 'Bio::EnsEMBL::Hive::RunnableDB::Dummy',
        -parameters => {
                       },
        -rc_name          => 'default',
        -can_be_empty  => 1,
      },


     {
        # Create input ids for individual prediction transcripts. Takes a slice as an input id and converts it
        # to a set of input ids that are individual dbIDs for the prediction transcripts. This avoids empty slices
        # being submitted as jobs and also means one feature corresponds to one job. Each species flows into this
        # independantly with 1mb slices. Also has the advantage that downstream analyses can start working as soon
        # as a single slice is finished
        -logic_name => 'create_prediction_transcript_ids',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveSubmitAnalysis',
        -parameters => {
                         target_db => $self->o('reference_db'),
                         feature_type => 'prediction_transcript',
                         slice_to_feature_ids => 1,
                         prediction_transcript_logic_names => ['genscan'],
                       },
        -flow_into => {
                        4 => ['run_uniprot_blast'],
                      },
        -rc_name    => 'default',
      },

##############################################################################
#
# BLAST ANALYSES
#
##############################################################################

      {
        # BLAST individual prediction transcripts against uniprot. The config settings are held lower in this
        # file in the master_config_settings sub
        -logic_name => 'run_uniprot_blast',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveBlastGenscanPep',
        -parameters => {
                         target_db => $self->o('reference_db'),
                         blast_db_path => $self->o('uniprot_blast_db_path'),
                         blast_exe_path => $self->o('uniprot_blast_exe_path'),
                         commandline_params => '-cpus 3 -hitdist 40',
                         repeat_masking_logic_names => ['repeatmasker_repbase_'.$self->o('repeatmasker_library')],
                         prediction_transcript_logic_names => ['genscan'],
                         iid_type => 'feature_id',
                         logic_name => 'uniprot',
                         module => 'HiveBlastGenscanPep',
                         config_settings => $self->get_config_settings('HiveBlast','HiveBlastGenscanPep'),
                      },
        -flow_into => {
                        -1 => ['run_uniprot_blast_himem'],
                        4 => ['run_vertrna_blast'],
                      },
        -rc_name    => 'blast',
        -failed_job_tolerance => 0.5,
        -hive_capacity => 900,
        -batch_size => 20,
      },

      {
        -logic_name => 'run_uniprot_blast_himem',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveBlastGenscanPep',
        -parameters => {
                         target_db => $self->o('reference_db'),
                         blast_db_path => $self->o('uniprot_blast_db_path'),
                         blast_exe_path => $self->o('uniprot_blast_exe_path'),
                         commandline_params => '-cpus 3 -hitdist 40',
                         repeat_masking_logic_names => ['repeatmasker_repbase_'.$self->o('repeatmasker_library')],
                         prediction_transcript_logic_names => ['genscan'],
                         iid_type => 'feature_id',
                         logic_name => 'uniprot',
                         module => 'HiveBlastGenscanPep',
                         config_settings => $self->get_config_settings('HiveBlast','HiveBlastGenscanPep'),
                      },
        -rc_name    => 'blast_himem',
        -can_be_empty  => 1,
        -flow_into => {
                        4 => ['run_vertrna_blast'],
                      },
       -failed_job_tolerance => 100,
       -hive_capacity => 900,
      },

      {
        # BLAST individual prediction transcripts against vertRNA. The config settings are held lower in this
        # file in the master_config_settings sub
        -logic_name => 'run_vertrna_blast',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveBlastGenscanDNA',
        -parameters => {
                         target_db => $self->o('reference_db'),
                         blast_db_path => $self->o('vertrna_blast_db_path'),
                         blast_exe_path => $self->o('vertrna_blast_exe_path'),
                         commandline_params => '-cpus 3 -hitdist 40',
                         repeat_masking_logic_names => ['repeatmasker_repbase_'.$self->o('repeatmasker_library')],
                         prediction_transcript_logic_names => ['genscan'],
                         iid_type => 'feature_id',
                         logic_name => 'vertrna',
                         module => 'HiveBlastGenscanDNA',
                         config_settings => $self->get_config_settings('HiveBlast','HiveBlastGenscanVertRNA'),
                      },
        -flow_into => {
                        -1 => ['run_vertrna_blast_himem'],
                        4 => ['run_unigene_blast'],
                      },
        -rc_name    => 'blast',
       -failed_job_tolerance => 0.5,
       -hive_capacity => 900,
       -batch_size => 20,
      },

      {
        -logic_name => 'run_vertrna_blast_himem',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveBlastGenscanDNA',
        -parameters => {
                         target_db => $self->o('reference_db'),
                         blast_db_path => $self->o('vertrna_blast_db_path'),
                         blast_exe_path => $self->o('vertrna_blast_exe_path'),
                         commandline_params => '-cpus 3 -hitdist 40',
                         repeat_masking_logic_names => ['repeatmasker_repbase_'.$self->o('repeatmasker_library')],
                         prediction_transcript_logic_names => ['genscan'],
                         iid_type => 'feature_id',
                         logic_name => 'vertrna',
                         module => 'HiveBlastGenscanDNA',
                         config_settings => $self->get_config_settings('HiveBlast','HiveBlastGenscanVertRNA'),
                      },
        -rc_name    => 'blast_himem',
        -can_be_empty  => 1,
        -flow_into => {
                        4 => ['run_unigene_blast'],
                      },
       -failed_job_tolerance => 100,
       -hive_capacity => 900,
    },

      {
        # BLAST individual prediction transcripts against unigene. The config settings are held lower in this
        # file in the master_config_settings sub
        -logic_name => 'run_unigene_blast',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveBlastGenscanDNA',
        -parameters => {
                         target_db => $self->o('reference_db'),
                         blast_db_path => $self->o('unigene_blast_db_path'),
                         blast_exe_path => $self->o('unigene_blast_exe_path'),
                         commandline_params => '-cpus 3 -hitdist 40',
                         prediction_transcript_logic_names => ['genscan'],
                         iid_type => 'feature_id',
                         repeat_masking_logic_names => ['repeatmasker_repbase_'.$self->o('repeatmasker_library')],
                         logic_name => 'unigene',
                         module => 'HiveBlastGenscanDNA',
                         config_settings => $self->get_config_settings('HiveBlast','HiveBlastGenscanUnigene'),
                      },
        -flow_into => {
                        -1 => ['run_unigene_blast_himem'],
                      },
        -rc_name    => 'blast',
        -failed_job_tolerance => 0.5,
        -hive_capacity => 900,
        -batch_size => 20,
      },

      {
        -logic_name => 'run_unigene_blast_himem',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveAssemblyLoading::HiveBlastGenscanDNA',
        -parameters => {
                         target_db => $self->o('reference_db'),
                         blast_db_path => $self->o('unigene_blast_db_path'),
                         blast_exe_path => $self->o('unigene_blast_exe_path'),
                         commandline_params => '-cpus 3 -hitdist 40',
                         prediction_transcript_logic_names => ['genscan'],
                         iid_type => 'feature_id',
                         repeat_masking_logic_names => ['repeatmasker_repbase_'.$self->o('repeatmasker_library')],
                         logic_name => 'unigene',
                         module => 'HiveBlastGenscanDNA',
                         config_settings => $self->get_config_settings('HiveBlast','HiveBlastGenscanUnigene'),
                      },
        -rc_name    => 'blast_himem',
        -can_be_empty  => 1,
        -failed_job_tolerance => 100,
        -hive_capacity => 900,
      },

      {
        # Creates a reference db for each species
        -logic_name => 'backup_core_db',
        -module     => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveCreateDatabase',
        -parameters => {
                         'source_db'        => $self->o('reference_db'),
                         'user_w'           => $self->o('user_w'),
                         'pass_w'           => $self->o('password'),
                         'create_type'      => 'backup',
                         'output_path'      => $self->o('output_path')."/core_db_bak/",
                         'backup_name'      => 'core_bak.sql',
                       },
        -rc_name    => 'default',
        -flow_into => { 1 => ['assembly_loading_report'] },
      },

      {
        -logic_name => 'assembly_loading_report',
        -module => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
        -parameters => {
                         cmd => 'perl '.$self->o('loading_report_script').
                                ' -user '.$self->o('user_r').
                                ' -host '.$self->o('reference_db','-host').
                                ' -port '.$self->o('reference_db','-port').
                                ' -dbname '.$self->o('reference_db','-dbname').
                                ' -report_type assembly_loading'.
                                ' > '.$self->o('output_path').'/loading_report.txt'
                       },
         -rc_name => 'default',
         -flow_into => { 1 => ['set_repeat_types','email_loading_report'] },
      },

      {
        -logic_name => 'email_loading_report',
        -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::TextfileByEmail',
        -parameters => {
                         email => $self->o('email_address'),
                         subject => 'AUTOMATED REPORT: assembly loading and feature annotation for '.$self->o('reference_db','-dbname').' completed',
                         text => 'Assembly loading and feature annotation have completed for '.$self->o('reference_db','-dbname').". Basic stats can be found below",
                         file => $self->o('output_path').'/loading_report.txt',
                       },
        -rc_name => 'default',
      },

      {
        -logic_name => 'set_repeat_types',
        -module => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
        -parameters => {
                         cmd => 'perl '.$self->o('enscode_root_dir').'/ensembl/misc-scripts/repeats/repeat-types.pl'.
                                ' -user '.$self->o('user_w').
                                ' -pass '.$self->o('password').
                                ' -host '.$self->o('reference_db','-host').
                                ' -port '.$self->o('reference_db','-port').
                                ' -dbpattern '.$self->o('reference_db','-dbname')
                       },
         -rc_name => 'default',
         -flow_into => { 1 => ['set_meta_coords'] },
      },

      {
        -logic_name => 'set_meta_coords',
        -module => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
        -parameters => {
                         cmd => 'perl '.$self->o('enscode_root_dir').'/ensembl/misc-scripts/meta_coord/update_meta_coord.pl'.
                                ' -user '.$self->o('user_w').
                                ' -pass '.$self->o('password').
                                ' -host '.$self->o('reference_db','-host').
                                ' -port '.$self->o('reference_db','-port').
                                ' -dbpattern '.$self->o('reference_db','-dbname')
                       },
         -rc_name => 'default',
         -flow_into => { 1 => ['set_meta_levels'] },
      },

      {
        -logic_name => 'set_meta_levels',
        -module => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
        -parameters => {
                         cmd => 'perl '.$self->o('enscode_root_dir').'/ensembl/misc-scripts/meta_levels.pl'.
                                ' -user '.$self->o('user_w').
                                ' -pass '.$self->o('password').
                                ' -host '.$self->o('reference_db','-host').
                                ' -port '.$self->o('reference_db','-port').
                                ' -dbname '.$self->o('reference_db','-dbname')
                       },
         -rc_name => 'default',
      },


      {
        -logic_name => 'wait_for_annotation_file',
        -module     => 'Bio::EnsEMBL::Hive::RunnableDB::Dummy',
        -parameters => {
                       },
        -rc_name    => 'default',
        -flow_into  => {
                          1 => ['load_annotation_file'],
                       },
      },

      {
        -logic_name => 'load_annotation_file',
        -module => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
        -parameters => {
                         cmd => 'perl '.$self->o('gtf_parsing_script').
                                ' -user '.$self->o('user_w').
                                ' -pass '.$self->o('password').
                                ' -host '.$self->o('reference_db','-host').
                                ' -port '.$self->o('reference_db','-port').
                                ' -dbname '.$self->o('reference_db','-dbname').
                                ' -dna_user '.$self->o('user_r').
                                ' -dna_host '.$self->o('reference_db','-host').
                                ' -dna_port '.$self->o('reference_db','-port').
                                ' -dna_dbname '.$self->o('reference_db','-dbname').
                                ' -gtf_file '.$self->o('output_path').'/annotation_file.gtf'
                       },
         -rc_name => 'load_annotation',
         -flow_into => { 1 => ['load_external_db_ids_and_optimise_af_tables'] },
         -wait_for => ['set_meta_levels'],
      },

      {
        -logic_name => 'load_external_db_ids_and_optimise_af_tables',
        -module => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
        -parameters => {
                         cmd => 'perl '.$self->o('enscode_root_dir').'/ensembl-analysis/scripts/genebuild/load_external_db_ids_and_optimize_af.pl'.
                                ' -output_path '.$self->o('output_path').'/optimise_daf_paf'.
                                ' -uniprot_filename '.$self->o('uniprot_index').
                                ' -dbuser '.$self->o('user_w').
                                ' -dbpass '.$self->o('password').
                                ' -dbhost '.$self->o('reference_db','-host').
                                ' -dbname '.$self->o('reference_db','-dbname').
                                ' -prod_dbuser '.$self->o('user_r').
                                ' -prod_dbhost '.$self->o('production_db','-host').
                                ' -prod_dbname '.$self->o('production_db','-dbname').
                                ' -prod_dbport '.$self->o('production_db','-port').
                                ' -verbose'
                        },
        -rc_name => 'optimise_daf_paf',
        -flow_into => { 1 => ['annotation_loading_report'] },
      },

      {
        -logic_name => 'annotation_loading_report',
        -module => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
        -parameters => {
                         cmd => 'perl '.$self->o('loading_report_script').
                                ' -user '.$self->o('user_r').
                                ' -host '.$self->o('reference_db','-host').
                                ' -port '.$self->o('reference_db','-port').
                                ' -dbname '.$self->o('reference_db','-dbname').
                                ' -report_type annotation'.
                                ' > '.$self->o('output_path').'/annotation_report.txt'
                       },
         -rc_name => 'default',
         -flow_into => { 1 => ['email_annotation_report'] },
      },

      {
        -logic_name => 'email_annotation_report',
        -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::TextfileByEmail',
        -parameters => {
                         email => $self->o('email_address'),
                         subject => 'AUTOMATED REPORT: annotation loading for '.$self->o('reference_db','-dbname').' completed',
                         text => 'Loading of annotation has been completed for '.$self->o('reference_db','-dbname').". Basic stats can be found below",
                         file => $self->o('output_path').'/annotation_report.txt',
                       },
        -rc_name => 'default',
      },

    ];
}



sub pipeline_wide_parameters {
    my ($self) = @_;

    return {
        %{ $self->SUPER::pipeline_wide_parameters() },  # inherit other stuff from the base class
    };
}

# override the default method, to force an automatic loading of the registry in all workers
#sub beekeeper_extra_cmdline_options {
#    my $self = shift;
#    return "-reg_conf ".$self->o("registry");
#}

sub resource_classes {
  my $self = shift;

  # Note that this builds resource requests off some of the variables at the top. Works off the idea
  # that the references all get put on one server and the pipe db is on another
  my $reference_db_server = $self->default_options()->{'reference_db_server'};
  my $pipe_db_server = $self->default_options()->{'pipe_db_server'};

  my $reference_db_server_number;
  my $pipe_db_server_number;



  my $num_tokens = $self->default_options()->{'num_tokens'};

  unless($reference_db_server =~ /(\d+)$/) {
    die "Failed to parse the server number out of the reference db server name. This is needed for setting tokens\n".
        "reference_db_server: ".$reference_db_server;
  }

  $reference_db_server_number = $1;

  unless($pipe_db_server =~ /(\d+)$/) {
    die "Failed to parse the server number out of the pipeline db server name. This is needed for setting tokens\n".
        "pipe_db_server: ".$pipe_db_server;
  }

  $pipe_db_server_number = $1;


  unless($num_tokens) {
    die "num_tokens is uninitialised or zero. num_tokens needs to be present in default_options and not zero\n".
        "num_tokens: ".$pipe_db_server;
  }



  return {
    'default' => { LSF => '-q normal -M900 -R"select[mem>900] rusage[mem=900,myens_build'.
                          $reference_db_server_number.'tok='.$num_tokens.',myens_build'.$pipe_db_server_number.'tok='.$num_tokens.']"' },
    'default_himem' => { LSF => '-q normal -M2900 -R"select[mem>2900] rusage[mem=2900,myens_build'.
                          $reference_db_server_number.'tok='.$num_tokens.',myens_build'.$pipe_db_server_number.'tok='.$num_tokens.']"' },
    'repeatmasker' => { LSF => '-q normal -M2900 -R"select[mem>2900] rusage[mem=2900,myens_build'.
                                $reference_db_server_number.'tok='.$num_tokens.',myens_build'.$pipe_db_server_number.'tok='.$num_tokens.']"' },
    'repeatmasker_himem' => { LSF => '-q normal -M5900 -R"select[mem>5900] rusage[mem=5900,myens_build'.
                                     $reference_db_server_number.'tok='.$num_tokens.',myens_build'.$pipe_db_server_number.'tok='.$num_tokens.']"' },
    'simple_features' => { LSF => '-q normal -M2900 -R"select[mem>2900] rusage[mem=2900,myens_build'.
                                  $reference_db_server_number.'tok='.$num_tokens.',myens_build'.$pipe_db_server_number.'tok='.$num_tokens.']"' },
    'genscan' => { LSF => '-q normal  -W 180 -M2900 -R"select[mem>2900] rusage[mem=2900,myens_build'.
                          $reference_db_server_number.'tok='.$num_tokens.',myens_build'.$pipe_db_server_number.'tok='.$num_tokens.']"' },
    'genscan_short' => { LSF => '-q normal -W 60 -M5900 -R"select[mem>5900] rusage[mem=5900,myens_build'.
                          $reference_db_server_number.'tok='.$num_tokens.',myens_build'.$pipe_db_server_number.'tok='.$num_tokens.']"' },
    'blast' => { LSF => '-q normal -M2900 -n 3 -R "select[mem>2900] rusage[mem=2900,myens_build'.
                        $reference_db_server_number.'tok='.$num_tokens.',myens_build'.$pipe_db_server_number.'tok='.$num_tokens.'] span[hosts=1]"' },
    'blast_himem' => { LSF => '-q normal -M5900 -n 3 -R "select[mem>5900] rusage[mem=5900,myens_build'.
                        $reference_db_server_number.'tok='.$num_tokens.',myens_build'.$pipe_db_server_number.'tok='.$num_tokens.'] span[hosts=1]"' },
    'optimise_daf_paf' => { LSF => '-q normal -M9000 -R "select[mem>9000] rusage[mem=9000,myens_build'.
                           $reference_db_server_number.'tok='.$num_tokens.',myens_build'.$pipe_db_server_number.'tok='.$num_tokens.']"' },
    'load_annotation' => { LSF => '-q normal -M9900 -R"select[mem>9900] rusage[mem=9900,myens_build'.
                           $reference_db_server_number.'tok='.$num_tokens.',myens_build'.$pipe_db_server_number.'tok='.$num_tokens.']"' },
  }
}

sub get_config_settings {

   # This is a helper sub created to access parameters that historically were held in separate configs in the
   # old pipeline. These are now stored in the master_config_settings sub below this one. In the analyses hashes
   # earlier in the config sets of these param can be requested and stored in the config_settings hash which
   # is them passed in as a parameter to the analysis. The converted analysis modules have code to take the key
   # value pairs from the config_settings hash and assign the values to the getter/setter sub associated with the
   # key.

   # Shift in the group name (a hash that has a collection of logic name hashes and a default hash)
   # Shift in the logic name of the specific analysis
   my $self = shift;
   my $config_group = shift;
   my $config_logic_name = shift;

   # And additional hash keys will be stored in here
   my @additional_configs = @_;

   # Return a ref to the master hash for the group using the group name
   my $config_group_hash = $self->master_config_settings($config_group);
   unless(defined($config_group_hash)) {
     die "You have asked for a group name in master_config_settings that doesn't exist. Group name:\n".$config_group;
   }
   # Final hash is the hash reference that gets returned. It is important to note that the keys added have
   # priority based on the call to this subroutine, with priority from left to right. Keys assigned to
   # $config_logic_name will have most priority, then keys in any additional hashes, then keys from the
   # default hash. A default hash key will never override a $config_logic_name key
   my $final_hash;

   # Add keys from the logic name hash
   my $config_logic_name_hash = $config_group_hash->{$config_logic_name};
   unless(defined($config_logic_name_hash)) {
     die "You have asked for a logic name hash that doesn't exist in the group you specified.\n".
         "Group name:\n".$config_group."\nLogic name:\n".$config_logic_name;
   }

   $final_hash = $self->add_keys($config_logic_name_hash,$final_hash);

   # Add keys from any additional hashes passed in, keys that are already present will not be overriden
   foreach my $additional_hash (@additional_configs) {
     my $config_additional_hash = $config_group_hash->{$additional_hash};
     $final_hash = $self->add_keys($config_additional_hash,$final_hash);
   }

   # Default is always loaded and has the lowest key value priority
   my $config_default_hash = $config_group_hash->{'Default'};
   $final_hash = $self->add_keys($config_default_hash,$final_hash);

   return($final_hash);
}

sub add_keys {
  my ($self,$hash_to_add,$final_hash) = @_;

  foreach my $key (keys(%$hash_to_add)) {
    unless(exists($final_hash->{$key})) {
      $final_hash->{$key} = $hash_to_add->{$key};
    }
  }

  return($final_hash);
}

sub master_config_settings {

  my ($self,$config_group) = @_;
  my $master_config_settings = {

  HiveBlast => {
    Default => {
      BLAST_PARSER => 'Bio::EnsEMBL::Analysis::Tools::BPliteWrapper',
      PARSER_PARAMS => {
        -regex => '^(\w+)',
        -query_type => undef,
        -database_type => undef,
      },
      BLAST_FILTER => undef,
      FILTER_PARAMS => {},
      BLAST_PARAMS => {
        -unknown_error_string => 'FAILED',
        -type => 'wu',
      }
    },

    HiveBlastGenscanPep => {
      BLAST_PARSER => 'Bio::EnsEMBL::Analysis::Tools::FilterBPlite',
      PARSER_PARAMS => {
                         -regex => '^(\w+\W\d+)',
                         -query_type => 'pep',
                         -database_type => 'pep',
                         -threshold_type => 'PVALUE',
                         -threshold => 0.01,
                       },
      BLAST_FILTER => 'Bio::EnsEMBL::Analysis::Tools::FeatureFilter',
      FILTER_PARAMS => {
                         -min_score => 200,
                         -prune => 1,
                       },
    },

    HiveBlastGenscanVertRNA => {
      BLAST_PARSER => 'Bio::EnsEMBL::Analysis::Tools::FilterBPlite',
      PARSER_PARAMS => {
                         -regex => '^(\w+\W\d+)',
                         -query_type => 'pep',
                         -database_type => 'dna',
                         -threshold_type => 'PVALUE',
                         -threshold => 0.001,
                       },
      BLAST_FILTER => 'Bio::EnsEMBL::Analysis::Tools::FeatureFilter',
      FILTER_PARAMS => {
                         -prune => 1,
                       },
    },

    HiveBlastGenscanUnigene => {
      BLAST_PARSER => 'Bio::EnsEMBL::Analysis::Tools::FilterBPlite',
      PARSER_PARAMS => {
                         -regex => '\/ug\=([\w\.]+)',
                         -query_type => 'pep',
                         -database_type => 'dna',
                         -threshold_type => 'PVALUE',
                         -threshold => 0.001,
                       },
      BLAST_FILTER => 'Bio::EnsEMBL::Analysis::Tools::FeatureFilter',
      FILTER_PARAMS => {
                         -prune => 1,
                       },
      },
    },

  };

  return($master_config_settings->{$config_group});

}

1;
