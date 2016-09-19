# Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
# Copyright [2016] EMBL-European Bioinformatics Institute
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package HiveMerge_conf;

use strict;
use warnings;

use Bio::EnsEMBL::Hive::Version 2.4;
use Bio::EnsEMBL::Hive::PipeConfig::HiveGeneric_conf;           # Allow this particular config to use conditional dataflow

use parent ('Bio::EnsEMBL::Analysis::Hive::Config::HiveBaseConfig_conf');

use Bio::EnsEMBL::ApiVersion qw/software_version/;
use Env qw(ENSCODE);

sub default_options {
  my ($self) = @_;

  return {
    # Inherit other stuff from the parent class
    %{$self->SUPER::default_options()},

    # Name of the pipeline
    'pipeline_name' => 'merge',

    # Set to 1 if you want to delete the vega and core databases.
    # Only useful if you want to start the whole pipeline again.
    # You also need to specify the driver if you want the DROP to work,
    # the easiest is to set the driver in your database hash like this:
    # -driver => $self->o('pipeline_db', '-driver'),
    'drop_databases' => 0,

    # If you are working on human and mouse you need the CCDS. If you are doing the merge
    # for any other species which does NOT have CCDS, set process_ccds to 0
    'process_ccds' => 1,

    # users and passwords for read-only and write access to the genebuild MySQL servers
    'pass_r' => '',
    'user_r' => '',
    'pass_w' => '',
    'user_w' => '',
    'user' => $self->o('user_w'),
    'password' => $self->o('pass_w'),

    # output directory. The merge will write log files here. The directory must not already exist.
    'output_dir' => '',

    # name of the directory where the vega checks reports will be written. This directory must not be neither output_dir nor a subdirectory of output_dir.
    'reports_dir' => '',

    # email to send the vega checks reports to
    'vega_checks_reports_email' => '@ebi.ac.uk',

    # email to send the missing CCDS report to
    'ccds_report_email' => '@ebi.ac.uk',

    # name of the files containing the temporary original vega and ensembl database dumps
    'vega_tmp_filename' => 'vegadump.tmp',
    'ensembl_tmp_filename' => 'ensembldump.tmp',

    # name of the file containing the temporary previous core database dump
    'prevcore_tmp_filename' => 'prevcoredump.tmp',

    # name of the file containing the list of processed gene ids after running the merge
    'processed_genes_filename' => 'havana_merge_list_processed_genes.ids',

    # name of the file containing the list of unprocessed gene ids to be copied from the Ensembl to the merge db
    # after running the merge
    'unprocessed_genes_filename' => 'havana_merge_list_unprocessed_genes.ids',

    # name of the file containing the list of genes from the Havana db to be merged
    'vega_genes_for_merge_filename' => 'vega_genes_for_merge.ids',

    # name of the file containing the list of genes from the merge db to be copied into the core db
    # (it will be all of them but this allows us to chunk the file and speed up the process by running multiple copy_genes processes in parallel)
    'merge_genes_for_copy_filename' => 'merge_genes_for_copy.ids',

    # name of the file containing the list of core db tables which will be dumped from the previous core db
    # and loaded into the new core db
    'core_db_tables_filename' => 'core_db_tables_for_dump.list',

    # name of the file containing the list of genes from the core db to be deleted just after its creation
    'core_genes_for_deletion_filename' => 'core_genes_for_deletion.ids',

    # name of the file containing the dump of the core database after the merge
    'backup_dump_core_db_after_merge_filename' => 'backup_dump_core_db_after_merge.sql',

    # name of the files containing the list of missing CCDS before copying the missing CCDS into the Ensembl db
    'ensembl_missing_ccds_filename1' => 'ensembl_missing_ccds_1.txt',
    'vega_missing_ccds_filename1' => 'vega_missing_ccds_1.txt',
    'missing_ccds_filename1' => 'missing_ccds_1.txt',
    
    # name of the files containing the list of missing CCDS after copying the missing CCDS into the Ensembl db
    # this file contents should always be empty after running the corresponding analysis
    'ensembl_missing_ccds_filename2' => 'ensembl_missing_ccds_2.txt',
    'vega_missing_ccds_filename2' => 'vega_missing_ccds_2.txt',
    'missing_ccds_filename2' => 'missing_ccds_2.txt',

    # The number of jobs in the job array for the merge script. The workload will be evenly
    # distributed over these jobs no matter what number of jobs you put here.
    'njobs' => '45',#'75',

    # The maximum number of consecutive jobs for the merge code to run at any point in time.
    # A number between 10 and 20 seems to be optimal.
    'concurrent' => '15',

    # assembly path without patch update extension required by some scripts
    'assembly_path' => 'GRCh38',

    # full path to uniprot file to be used for the script which assigns the external DB IDs and optimises the align feature tables
    'uniprot_file' => '../Ensembl/uniprot_2015_12/entry_loc',

    # full path to your local copy of the ensembl-analysis git repository
    'ensembl_analysis_base' => '$ENSCODE/ensembl-analysis',

    # database parameters
    'default_port' => 3306, # default port to be used for all databases except the original vega db provided by the Vega team
    'default_host' => 'genebuildXX', # default host to be used for the pipeline, vega and core databases. Used to build the resource requirements.

    'original_ensembl_host' => '', # vega database provided by the Vega team
    'original_ensembl_port' => '',
    'original_ensembl_name' => '',

    'original_vega_host' => '', # vega database provided by the Vega team
    'original_vega_port' => '',
    'original_vega_name' => '',

    'ensembl_host' => '', # ensembl database to be used for the merge
    'ensembl_name' => '',

    'ccds_host' => '', # ccds database containing the CCDS gene set
    'ccds_name' => '',

    'prevcore_host' => '', # previous core database (available on staging or live)
    'prevcore_name' => '',

    'production_host' => '', # production database (available on staging)
    'production_name' => '',

    'pipe_dbname' => '', # pipeline db, automatically created

    'vega_name' => '', # vega database to be used for the merge

    'core_name' => '', # core database which will contain the merged gene set at the end of the process

    'vega_host' => $self->o('default_host'),
    'core_host' => $self->o('default_host'),
    'pipe_db_server' => $self->o('default_host'),

    ##
    # You shouldn't need to change anything below this line
    ##

    ## Required by HiveBaseConfig_conf
    #reference_db (not required in the merge process, leave blank)
    'reference_dbname' => '',
    'reference_db_server' => '',
    'port' => '',
    #'user_r' => '',
    #dna_db (not required in the merge process, leave blank)
    'dna_dbname' => '',
    'dna_db_server' => '',
    #'port' => '',
    #'user_r' => '',

    # original Ensembl database (used in previous release)
    'original_ensembl_db' => {
                    -host      => $self->o('original_ensembl_host'),
                    -port      => $self->o('original_ensembl_port'),
                    -user      => $self->o('user_r'),
                    -pass      => $self->o('pass_r'),
                    -dbname    => $self->o('original_ensembl_name'),
    },

    # vega database provided by the Vega team
    'original_vega_db' => {
                    -host      => $self->o('original_vega_host'),
                    -port      => $self->o('original_vega_port'),
                    -user      => $self->o('user_r'),
                    -pass      => $self->o('pass_r'),
                    -dbname    => $self->o('original_vega_name'),
    },

    # ensembl database to be used for the merge
    'ensembl_db' => {
                    -host      => $self->o('ensembl_host'),
                    -port      => $self->o('default_port'),
                    -user      => $self->o('user_w'),
                    -pass      => $self->o('pass_w'),
                    -dbname    => $self->o('ensembl_name'),
    },

    # ccds database containing the CCDS gene set
    'ccds_db' => {
                    -host      => $self->o('ccds_host'),
                    -port      => $self->o('default_port'),
                    -user      => $self->o('user_r'),
                    -pass      => $self->o('pass_r'),
                    -dbname    => $self->o('ccds_name'),
    },

    # previous core database (available on ens-staging or ens-livemirror)
    'prevcore_db' => {
                    -host      => $self->o('prevcore_host'),
                    -port      => $self->o('default_port'),
                    -user      => $self->o('user_r'),
                    -pass      => $self->o('pass_r'),
                    -dbname    => $self->o('prevcore_name'),
    },
    'db_conn' => 'mysql://'.$self->o('user_r').'@'.$self->o('prevcore_host').'/'.$self->o('prevcore_name'),

    # pipeline db, pipeline will create this automatically
    'pipeline_db' => {
                    -host      => $self->o('default_host'),
                    -port      => $self->o('default_port'),
                    -user      => $self->o('user_w'),
                    -pass      => $self->o('pass_w'),
                    -dbname    => $self->o('pipe_dbname'),
                    -driver    => "mysql",
    },

    # vega database to be used for the merge
    'vega_db' => {
                    -host      => $self->o('vega_host'),
                    -port      => $self->o('default_port'),
                    -user      => $self->o('user_w'),
                    -pass      => $self->o('pass_w'),
                    -dbname    => $self->o('vega_name'),
                    -driver    => $self->o('pipeline_db', '-driver'),
    },

    # core database
    'core_db' => {
                    -host      => $self->o('core_host'),
                    -port      => $self->o('default_port'),
                    -user      => $self->o('user_w'),
                    -pass      => $self->o('pass_w'),
                    -dbname    => $self->o('core_name'),
                    -driver    => $self->o('pipeline_db', '-driver'),
    },

    # production database
    'production_db' => {
                    -host      => $self->o('production_host'),
                    -port      => $self->o('default_port'),
                    -user      => $self->o('user_r'),
                    -pass      => $self->o('pass_r'),
                    -dbname    => $self->o('production_name'),
    },

  };
}

sub resource_classes {
      my $self = shift;
          return {
            'default' => { 'LSF' => $self->lsf_resource_builder('normal',900,[$self->default_options->{'default_host'}]) },
            'normal_1500' => { 'LSF' => $self->lsf_resource_builder('normal',1500,[$self->default_options->{'default_host'}]) },
            'normal_4600' => { 'LSF' => $self->lsf_resource_builder('normal',4600,[$self->default_options->{'default_host'}]) },
            'normal_7900' => { 'LSF' => $self->lsf_resource_builder('normal',7900,[$self->default_options->{'default_host'}]) },
            'normal_12000' => { 'LSF' => $self->lsf_resource_builder('normal',12000,[$self->default_options->{'default_host'}]) },
            'local' => {'LOCAL' => ''},
                }
}

sub pipeline_create_commands {
  my ($self) = @_;

  my $create_commands = $self->SUPER::pipeline_create_commands;
  if ($self->o('drop_databases')) {
    foreach my $dbname ('vega_db','core_db') {
      push(@$create_commands,$self->db_cmd('DROP DATABASE IF EXISTS', $self->dbconn_2_url($dbname)));
    }
  }
  return $create_commands;
}

sub pipeline_analyses {
  my ($self) = @_;

  return [
            {
              -logic_name => 'create_reports_dir',
              -module     => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
              -parameters => {
                               'cmd'   => 'mkdir -p '.$self->o('reports_dir').";".
                                          'mkdir -p '.$self->o('output_dir')
                             },
              -flow_into => { 1 => ['create_vega_db'] },
              -rc_name => 'default',
              -input_ids => [ {} ],
            },

            {
              -logic_name => 'create_ensembl_db',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
              -parameters => {
                                'cmd'   => 'mysql -NB -u'.$self->o('user_w').
                                               ' -p'.$self->o('pass_w').
                                               ' -h'.$self->o('ensembl_db','-host').
                                               ' -P'.$self->o('ensembl_db','-port').
                                               ' -e "CREATE DATABASE '.$self->o('ensembl_db','-dbname').'"'
                             },
              -input_ids => [ {} ],
              -rc_name => 'default',
              -flow_into => { 1 => ['list_ensembl_db_tables'] },
            },

            {
              -logic_name => 'list_ensembl_db_tables',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::JobFactory',
              -parameters => {
                               'db_conn'    => $self->o('original_ensembl_db'),
                               'inputquery' => 'SHOW TABLE STATUS',
                             },
              -rc_name => 'default',
              -flow_into => { '2->A' => { 'parallel_dump_ensembl_db' => { 'table_name' => '#Name#' }, },
                              'A->1' => ['ensembl_db_creation_completed'] },
            },
            
            {
              -logic_name => 'ensembl_db_creation_completed',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
              -parameters => {
                               'cmd'   => 'echo "Ensembl db creation completed."'
                             },
              -rc_name => 'default',
            },

            {
              -logic_name => 'parallel_dump_ensembl_db',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::DbCmd',
              -parameters => {
                               'db_conn'       => $self->o('original_ensembl_db'),
                               'output_file'   => $self->o('output_dir').'/'.$self->o('original_ensembl_db','-dbname').'_'.'#table_name#.sql',
                               'executable'    => 'mysqldump',
                               'append'        => ['#table_name#'],
                             },
               -analysis_capacity => 200,
               -hive_capacity => 200,
               -max_retry_count => 2,
               -rc_name => 'normal_1500',
               -flow_into => { 1 => ['parallel_load_ensembl_db'] },
            },

            {
              -logic_name => 'parallel_load_ensembl_db',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::DbCmd',
              -parameters => {
                                 db_conn => $self->o('ensembl_db'),
                                 input_file => $self->o('output_dir').'/'.$self->o('original_ensembl_db','-dbname').'_'.'#table_name#.sql',
                             },
              -rc_name => 'normal_1500',
            },         

            {
              -logic_name => 'create_vega_db',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveCreateDatabase',
              -parameters => {
              	                create_type => 'copy',
                                source_db => $self->o('original_vega_db'),
                                target_db => $self->o('vega_db'),
                                pass_w => $self->o('pass_w'),
                                user_w => $self->o('user_w'),
                                db_dump_file => $self->o('output_dir').'/'.$self->o('vega_tmp_filename'),
                                #ignore_dna => 1, # the vega db does not have any dna
                             },
             -flow_into => { 1 => ['list_toplevel_for_vega_checks_before'] },
            },

            {
              -logic_name => 'create_core_db',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
              -parameters => {
                                'cmd'   => 'mysql -NB -u'.$self->o('user_w').
                                               ' -p'.$self->o('pass_w').
                                               ' -h'.$self->o('core_db','-host').
                                               ' -P'.$self->o('core_db','-port').
                                               ' -e "CREATE DATABASE '.$self->o('core_db','-dbname').'"'
                             },
              -input_ids => [ {} ],
              -rc_name => 'default',
              -flow_into => { 1 => ['list_core_db_tables'] },
            },

            {
              -logic_name => 'list_core_db_tables',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::JobFactory',
              -parameters => {
                               'db_conn'    => $self->o('prevcore_db'),
                               'inputquery' => 'SHOW TABLE STATUS',
                             },
              -rc_name => 'default',
              -flow_into => { '2->A' => { 'parallel_dump_core_db' => { 'table_name' => '#Name#' }, },
                              'A->1' => ['list_core_genes'] },
            },

            {
              -logic_name => 'parallel_dump_core_db',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::DbCmd',
              -parameters => {
                               'db_conn'       => $self->o('prevcore_db'),
                               'output_file'   => $self->o('output_dir').'/#table_name#.sql',
                               'executable'    => 'mysqldump',
                               'append'        => ['#table_name#'],
                             },
               -analysis_capacity => 200,
               -hive_capacity => 200,
               -max_retry_count => 2,
               -rc_name => 'normal_1500',
               -flow_into => { 1 => ['parallel_load_core_db'] },
            },

            {
              -logic_name => 'parallel_load_core_db',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::DbCmd',
              -parameters => {
                                 db_conn => $self->o('core_db'),
                                 input_file => $self->o('output_dir').'/#table_name#.sql',
                             },
              -rc_name => 'normal_1500',
              #-flow_into => { 1 => ['list_core_genes'] },
            },

            {
              -logic_name => 'list_core_genes',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::DbCmd',
              -parameters => {
                               db_conn     => $self->o('core_db'),
                               append      => ['-NB'],
                               input_query => 'SELECT gene_id FROM gene g,seq_region sr WHERE g.seq_region_id=sr.seq_region_id AND name <> "MT"',
                               output_file => $self->o('output_dir').'/'.$self->o('core_genes_for_deletion_filename'),
                             },
              -rc_name => 'default',
              -flow_into => { 1 => ['chunk_core_genes'] },
            },

            {

              -logic_name => 'chunk_core_genes',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::FileFactory',
              -parameters => {
                               inputfile => $self->o('output_dir').'/'.$self->o('core_genes_for_deletion_filename'),
                               output_dir => $self->o('output_dir'),
                               output_prefix => $self->o('core_genes_for_deletion_filename')."_chunk_",
                             },

              -flow_into => { '2->A' => [ 'delete_core_genes' ],
                              'A->1' => [ 'core_sql_truncates' ],
                            },
              -rc_name => 'default',
            },

            {
              -logic_name => 'delete_core_genes',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
              -parameters => {
                               cmd => 'perl '.$self->o('ensembl_analysis_base').'/scripts/genebuild/delete_genes.pl'
                                     ." -dbhost ".$self->o('core_db','-host')
                                     ." -dbuser ".$self->o('core_db','-user')
                                     ." -dbpass ".$self->o('core_db','-pass')
                                     ." -dbname ".$self->o('core_db','-dbname')
                                     ." -dbport ".$self->o('core_db','-port')
                                     ." -idfile #file#"

                             },
               -analysis_capacity => 25,
               -hive_capacity => 25,
               -max_retry_count => 2,
               -rc_name => 'normal_1500',
            },
            {
              -logic_name => 'core_sql_truncates',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::SqlCmd',
              -parameters => {
                               db_conn => $self->o('core_db'),
                               sql => [ 'TRUNCATE xref',
                                        'TRUNCATE object_xref',
                                        'TRUNCATE external_synonym',
                                        'TRUNCATE dependent_xref',
                                        'TRUNCATE interpro',
                                        'TRUNCATE identity_xref',
                                        'TRUNCATE ontology_xref',
                                        'DELETE FROM unmapped_object WHERE type LIKE "xref"'
                                       ],
                             },
              -max_retry_count => 0,
              -rc_name => 'default',
            },

            {
              -logic_name => 'list_toplevel_for_vega_checks_before',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::JobFactory',
              -parameters => {
                               db_conn => $self->o('vega_db'),
                               inputquery => 'SELECT sr.name FROM seq_region sr, seq_region_attrib sra, attrib_type at WHERE sr.seq_region_id = sra.seq_region_id AND sr.name NOT LIKE "LRG\_%" AND sra.attrib_type_id = at.attrib_type_id AND code = "toplevel"',
                               column_names => ['chromosome'],
                             },
              -flow_into => { '2->A' => [ 'vega_checks_before' ],
                              'A->1' => [ 'vega_checks_before_concat' ],
                            },
              -rc_name => 'default',
            },

            {
              -logic_name => 'vega_checks_before',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveVegaChecks',
              -parameters => {
              	               dbname => $self->o('vega_db','-dbname'),
                               dbhost => $self->o('vega_db','-host'),
                               dnadbname => $self->o('ensembl_db','-dbname'),
                               dnadbhost => $self->o('ensembl_db','-host'),
                               coord_system => 'toplevel',
                               path => $self->o('assembly_path'),
                               sql_output => $self->o('output_dir').'/vega_checks_before_#chromosome#.sql',
                               dbtype => '', # can be 'vega' or '' (empty string)
                               port => '3306',
                               user => $self->o('user_w'),
                               pass => $self->o('pass_w'),
                               #chromosome => '',
                               write => 1,
                               affix => 0, # perform the checks by using the biotypes with or without the prefixes and suffixes like weird_, _Ens, _hav, ... ; without affixes by default
                               biotypes_extension => 0,
                               stdout_file => $self->o('reports_dir').'/vega_checks_before_#chromosome#.out',
                               stderr_file => $self->o('reports_dir').'/vega_checks_before_#chromosome#.err',
                             },
              -hive_capacity    => 30,
              -analysis_capacity => 30,
              -wait_for => ['ensembl_db_creation_completed'],
            },
            {
              -logic_name => 'vega_checks_before_concat',
              -module     => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
              -parameters => {
                               'cmd'   => 'cat '.$self->o('reports_dir').'/vega_checks_before_*.out > '.
                                                 $self->o('reports_dir').'/vega_checks_before.out'
                             },
              -flow_into => { 1 => ['vega_checks_before_report'] },
              -rc_name => 'default',
            },
            {
              -logic_name => 'vega_checks_before_report',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::TextfileByEmail',
              -parameters => {
                               email => $self->o('vega_checks_reports_email'),
                               subject => 'AUTOMATED REPORT: vega biotype combinations',
                               text => 'Please find below the list of not allowed gene and transcript biotype combinations BEFORE the merge found in the vega database '.$self->o('vega_db','-dbname').'. Please note that any change applied to the list of allowed biotype combinations will take effect in a future release (not the next release).',
                               file => $self->o('reports_dir').'/vega_checks_before.out',
                               command => q{egrep '(Unknown)|(not allowed\.)' | awk '{print $9,$18}' | sort | uniq -c | sort -nr | sed s'/\. run/ (UNKNOWN gene biotype)/g'},
                             },
              -flow_into => { 1 => ['prepare_vega_db'] },
              -rc_name => 'default',
            },

            {
              -logic_name => 'prepare_vega_db',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveVegaPreparation',
              -parameters => {
                               output_path => $self->o('output_dir').'/vega_preparation/',
                               dbhost => $self->o('vega_db','-host'),
                               dbname => $self->o('vega_db','-dbname'),
                               dbuser => $self->o('user_w'),
                               dbpass => $self->o('pass_w'),
                               dbport => $self->o('vega_db','-port'),
                               dnadbhost => $self->o('ensembl_db','-host'),
                               dnadbport => $self->o('ensembl_db','-port'),
                               dnadbname => $self->o('ensembl_db','-dbname'),
                               check_vega_met_stop_dir => $self->o('ensembl_analysis_base').'/scripts/Merge',
                               skip => 0,
                               only => 0,
                             },
              -flow_into => { 1 => WHEN ('#process_ccds#' => ['set_ccds_biotype'],
                                   ELSE                      ['list_vega_genes_for_merge']) },
            },

            {
              -logic_name => 'set_ccds_biotype',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::SqlCmd',
              -parameters => {
                               db_conn => $self->o('ensembl_db'),
                               sql => ['UPDATE transcript SET biotype="ccds" WHERE stable_id LIKE "CCDS%"'],
                             },
              -flow_into => { 1 => ['delete_ccds'] },
            },

            {
              -logic_name => 'delete_ccds',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveDeleteTranscripts',
              -parameters => {
                               biotype => 'ccds',
                               dbhost => $self->o('ensembl_db','-host'),
                               dbname => $self->o('ensembl_db','-dbname'),
                               dbuser => $self->o('user_w'),
                               dbpass => $self->o('pass_w'),
                               dbport => $self->o('ensembl_db','-port'),
                               delete_transcripts_path => $self->o('ensembl_analysis_base').'/scripts/genebuild/',
                               delete_genes_path => $self->o('ensembl_analysis_base').'/scripts/genebuild/',
                               delete_transcripts_script_name => 'delete_transcripts.pl',
                               delete_genes_script_name => 'delete_genes.pl',
                               output_path => $self->o('output_dir').'/delete_ccds/',
                               output_file_name => 'delete_ccds.out',
                               email => $self->o('vega_checks_reports_email'),
                               from => 'ensembl-genebuild@ebi.ac.uk'
                             },
              -max_retry_count => 0,
              -flow_into => { 1 => ['list_ensembl_toplevel_for_update_ccds_labels'] },
            },

            {
              -logic_name => 'list_ensembl_toplevel_for_update_ccds_labels',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::JobFactory',
              -parameters => {
                               db_conn => $self->o('ensembl_db'),
                               inputquery => 'SELECT sr.name FROM seq_region sr, seq_region_attrib sra, attrib_type at WHERE sr.seq_region_id = sra.seq_region_id AND sr.name NOT LIKE "LRG\_%" AND sra.attrib_type_id = at.attrib_type_id AND code = "toplevel"',
                               column_names => ['chromosome'],
                             },
              -flow_into => { '2->A' => [ 'update_ensembl_ccds_labels' ],
                              'A->1' => [ 'update_ensembl_ccds_labels_concat' ],
                            },
              -rc_name => 'default',
            },

            {
              -logic_name => 'update_ensembl_ccds_labels',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveUpdateCCDSLabels',
              -parameters => {
                               ccds_dbname => $self->o('ccds_db','-dbname'),
                               ccds_host => $self->o('ccds_db','-host'),
                               ccds_user => $self->o('ccds_db','-user'),
                               output_dbname => $self->o('ensembl_db','-dbname'),
                               output_host => $self->o('ensembl_db','-host'),
                               output_user => $self->o('user_w'),
                               output_pass => $self->o('pass_w'),
                               dna_dbname => $self->o('ensembl_db','-dbname'),
                               dna_host => $self->o('ensembl_db','-host'),
                               dna_user => $self->o('user_r'),
                               dna_pass => $self->o('pass_r'),
                               assembly_path => $self->o('assembly_path'),
                               reports_dir => $self->o('reports_dir'),
                               output_filename => $self->o('ensembl_missing_ccds_filename1'), # this will get an extra extension corresponding to the chromosome name
                               #chromosome => '',
                             },
              -hive_capacity    => 30,
              -analysis_capacity => 30,
            },
            {
              -logic_name => 'update_ensembl_ccds_labels_concat',
              -module     => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
              -parameters => {
                               'cmd'   => 'cat '.$self->o('reports_dir').'/'.$self->o('ensembl_missing_ccds_filename1').'.* > '.
                                                 $self->o('reports_dir').'/'.$self->o('ensembl_missing_ccds_filename1')
                             },
              -flow_into => { 1 => ['list_vega_toplevel_for_update_ccds_labels'] },
              -rc_name => 'default',
            },

            {
              -logic_name => 'list_vega_toplevel_for_update_ccds_labels',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::JobFactory',
              -parameters => {
                               db_conn => $self->o('vega_db'),
                               inputquery => 'SELECT sr.name FROM seq_region sr, seq_region_attrib sra, attrib_type at WHERE sr.seq_region_id = sra.seq_region_id AND sr.name NOT LIKE "LRG\_%" AND sra.attrib_type_id = at.attrib_type_id AND code = "toplevel"',
                               column_names => ['chromosome'],
                             },
              -flow_into => { '2->A' => [ 'update_vega_ccds_labels' ],
                              'A->1' => [ 'update_vega_ccds_labels_concat' ],
                            },
              -rc_name => 'default',
            },

            {
              -logic_name => 'update_vega_ccds_labels',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveUpdateCCDSLabels',
              -parameters => {
                               ccds_dbname => $self->o('ccds_db','-dbname'),
                               ccds_host => $self->o('ccds_db','-host'),
                               ccds_user => $self->o('ccds_db','-user'),
                               output_dbname => $self->o('vega_db','-dbname'),
                               output_host => $self->o('vega_db','-host'),
                               output_user => $self->o('user_w'),
                               output_pass => $self->o('pass_w'),
                               dna_dbname => $self->o('ensembl_db','-dbname'),
                               dna_host => $self->o('ensembl_db','-host'),
                               dna_user => $self->o('user_r'),
                               dna_pass => $self->o('pass_r'),
                               assembly_path => $self->o('assembly_path'),
                               reports_dir => $self->o('reports_dir'),
                               output_filename => $self->o('vega_missing_ccds_filename1'), # this will get an extra extension corresponding to the chromosome name
                               #chromosome => '',
                             },
              -hive_capacity    => 30,
              -analysis_capacity => 30,
            },

            {
              -logic_name => 'update_vega_ccds_labels_concat',
              -module     => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
              -parameters => {
                               'cmd'   => 'cat '.$self->o('reports_dir').'/'.$self->o('vega_missing_ccds_filename1').'.* > '.
                                                 $self->o('reports_dir').'/'.$self->o('vega_missing_ccds_filename1')
                             },
              -flow_into => { 1 => ['create_missing_ccds_report1'] },
              -rc_name => 'default',
            },

            {
              -logic_name => 'create_missing_ccds_report1',
              -module     => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
              -parameters => {
                               'cmd'   => 'grep -Fx -f '.$self->o('reports_dir').'/'.$self->o('ensembl_missing_ccds_filename1').' '.
                                                 $self->o('reports_dir').'/'.$self->o('vega_missing_ccds_filename1').' > '.
                                                 $self->o('reports_dir').'/'.$self->o('missing_ccds_filename1')
                             },
              -flow_into => { 1 => ['email_missing_ccds_report1'] },
              -rc_name => 'default',
            },

            {
              -logic_name => 'email_missing_ccds_report1',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::TextfileByEmail',
              -parameters => {
                               email => $self->o('ccds_report_email'),
                               subject => 'AUTOMATED REPORT: missing CCDS before copying missing CCDS',
                               text => 'Please find below the list of missing CCDS models before copying the missing CCDS into the Ensembl database.',
                               file => $self->o('reports_dir').'/'.$self->o('missing_ccds_filename1'),
                               command => q{cat},
                             },
              -flow_into => { 1 => ['copy_missing_ccds'] },
              -rc_name => 'default',
            },

            {
              -logic_name => 'copy_missing_ccds',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveCopyGenes',
              -parameters => {
                               copy_genes_path => $self->o('ensembl_analysis_base').'/scripts/genebuild/',
                               copy_genes_script_name => 'copy_genes.pl',

                               # copy_genes.pl script parameters
                               sourcehost => $self->o('ccds_db','-host'),
                               sourceuser => $self->o('ccds_db','-user'),
                               sourceport => $self->o('ccds_db','-port'),
                               sourcepass => $self->o('ccds_db','-pass'),
                               sourcedbname => $self->o('ccds_db','-dbname'),
                               outhost => $self->o('ensembl_db','-host'),
                               outuser => $self->o('ensembl_db','-user'),
                               outpass => $self->o('ensembl_db','-pass'),
                               outdbname => $self->o('ensembl_db','-dbname'),
                               outport => $self->o('ensembl_db','-port'),
                               dnahost => $self->o('ensembl_db','-host'),
                               dnadbname => $self->o('ensembl_db','-dbname'),
                               dnauser => $self->o('user_r'),
                               dnaport => $self->o('ensembl_db','-port'),
                               logic => 'ensembl',
                               source => 'ensembl',
                               biotype => 'protein_coding',
                               stable_id => 1,
                               merge => 1,
                               file => $self->o('reports_dir').'/'.$self->o('missing_ccds_filename1'),
                             },
               -flow_into => { 1 => ['list_ensembl_toplevel_for_update_ccds_labels_after'] },
               -analysis_capacity => 20,
               -hive_capacity => 20,
               -max_retry_count => 0,
            },

            {
              -logic_name => 'list_ensembl_toplevel_for_update_ccds_labels_after',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::JobFactory',
              -parameters => {
                               db_conn => $self->o('ensembl_db'),
                               inputquery => 'SELECT sr.name FROM seq_region sr, seq_region_attrib sra, attrib_type at WHERE sr.seq_region_id = sra.seq_region_id AND sr.name NOT LIKE "LRG\_%" AND sra.attrib_type_id = at.attrib_type_id AND code = "toplevel"',
                               column_names => ['chromosome'],
                             },
              -flow_into => { '2->A' => [ 'update_ensembl_ccds_labels_after' ],
                              'A->1' => [ 'update_ensembl_ccds_labels_concat_after' ],
                            },
              -rc_name => 'default',
            },

            {
              -logic_name => 'update_ensembl_ccds_labels_after',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveUpdateCCDSLabels',
              -parameters => {
                               ccds_dbname => $self->o('ccds_db','-dbname'),
                               ccds_host => $self->o('ccds_db','-host'),
                               ccds_user => $self->o('ccds_db','-user'),
                               output_dbname => $self->o('ensembl_db','-dbname'),
                               output_host => $self->o('ensembl_db','-host'),
                               output_user => $self->o('user_w'),
                               output_pass => $self->o('pass_w'),
                               dna_dbname => $self->o('ensembl_db','-dbname'),
                               dna_host => $self->o('ensembl_db','-host'),
                               dna_user => $self->o('user_r'),
                               dna_pass => $self->o('pass_r'),
                               assembly_path => $self->o('assembly_path'),
                               reports_dir => $self->o('reports_dir'),
                               output_filename => $self->o('ensembl_missing_ccds_filename2'), # this will get an extra extension corresponding to the chromosome name
                               #chromosome => '',
                             },
              -hive_capacity    => 30,
              -analysis_capacity => 30,
            },
            {
              -logic_name => 'update_ensembl_ccds_labels_concat_after',
              -module     => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
              -parameters => {
                               'cmd'   => 'cat '.$self->o('reports_dir').'/'.$self->o('ensembl_missing_ccds_filename2').'.* > '.
                                                 $self->o('reports_dir').'/'.$self->o('ensembl_missing_ccds_filename2')
                             },
              -flow_into => { 1 => ['list_vega_toplevel_for_update_ccds_labels_after'] },
              -rc_name => 'default',
            },

            {
              -logic_name => 'list_vega_toplevel_for_update_ccds_labels_after',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::JobFactory',
              -parameters => {
                               db_conn => $self->o('vega_db'),
                               inputquery => 'SELECT sr.name FROM seq_region sr, seq_region_attrib sra, attrib_type at WHERE sr.seq_region_id = sra.seq_region_id AND sr.name NOT LIKE "LRG\_%" AND sra.attrib_type_id = at.attrib_type_id AND code = "toplevel"',
                               column_names => ['chromosome'],
                             },
              -flow_into => { '2->A' => [ 'update_vega_ccds_labels_after' ],
                              'A->1' => [ 'update_vega_ccds_labels_concat_after' ],
                            },
              -rc_name => 'default',
            },

            {
              -logic_name => 'update_vega_ccds_labels_after',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveUpdateCCDSLabels',
              -parameters => {
                               ccds_dbname => $self->o('ccds_db','-dbname'),
                               ccds_host => $self->o('ccds_db','-host'),
                               ccds_user => $self->o('ccds_db','-user'),
                               output_dbname => $self->o('vega_db','-dbname'),
                               output_host => $self->o('vega_db','-host'),
                               output_user => $self->o('user_w'),
                               output_pass => $self->o('pass_w'),
                               dna_dbname => $self->o('ensembl_db','-dbname'),
                               dna_host => $self->o('ensembl_db','-host'),
                               dna_user => $self->o('user_r'),
                               dna_pass => $self->o('pass_r'),
                               assembly_path => $self->o('assembly_path'),
                               reports_dir => $self->o('reports_dir'),
                               output_filename => $self->o('vega_missing_ccds_filename2'), # this will get an extra extension corresponding to the chromosome name
                               #chromosome => '',
                             },
              -hive_capacity    => 30,
              -analysis_capacity => 30,
            },

            {
              -logic_name => 'update_vega_ccds_labels_concat_after',
              -module     => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
              -parameters => {
                               'cmd'   => 'cat '.$self->o('reports_dir').'/'.$self->o('vega_missing_ccds_filename2').'.* > '.
                                                 $self->o('reports_dir').'/'.$self->o('vega_missing_ccds_filename2')
                             },
              -flow_into => { 1 => ['create_missing_ccds_report2'] },
              -rc_name => 'default',
            },

            {
              -logic_name => 'create_missing_ccds_report2',
              -module     => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
              -parameters => {
                               'cmd'   => 'grep -Fx -f '.$self->o('reports_dir').'/'.$self->o('ensembl_missing_ccds_filename2').' '.
                                                 $self->o('reports_dir').'/'.$self->o('vega_missing_ccds_filename2').' | cat > '.
                                                 $self->o('reports_dir').'/'.$self->o('missing_ccds_filename2')
                             },
              -flow_into => { 1 => ['email_missing_ccds_report2'] },
              -rc_name => 'default',
            },

            {
              -logic_name => 'email_missing_ccds_report2',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::TextfileByEmail',
              -parameters => {
                               email => $self->o('ccds_report_email'),
                               subject => 'AUTOMATED REPORT: missing CCDS after copying missing CCDS',
                               text => 'Please find below the list of missing CCDS models after copying the missing CCDS into the Ensembl database. NOTE THIS LIST SHOULD BE EMPTY. OTHERWISE THERE IS A PROBLEM.',
                               file => $self->o('reports_dir').'/'.$self->o('missing_ccds_filename2'),
                               command => q{cat},
                             },
              -flow_into => { 1 => ['list_vega_genes_for_merge'] },
              -rc_name => 'default',
            },

            {
              -logic_name => 'list_vega_genes_for_merge',
              -module     => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
              -parameters => {
                               'cmd'   => 'mysql -NB -u'.$self->o('user_r').
                                               ' -h'.$self->o('vega_db','-host').
                                               ' -D'.$self->o('vega_db','-dbname').
                                               ' -P'.$self->o('vega_db','-port').
                                               ' -e"SELECT gene_id from gene;" > '.
                                               $self->o('output_dir').'/'.$self->o('vega_genes_for_merge_filename')
                             },
              -flow_into => { 1 => ['chunk_vega_genes_for_merge'] },
              -rc_name => 'default',
            },

            {
              -logic_name => 'chunk_vega_genes_for_merge',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::FileFactory',
              -parameters => {
                               inputfile => $self->o('output_dir').'/'.$self->o('vega_genes_for_merge_filename'),
                               output_dir => $self->o('output_dir'),
                               output_prefix => $self->o('vega_genes_for_merge_filename')."_chunk_",
                             },
              -flow_into => { '2->A' => ['havana_merge'],
                              'A->1' => ['havana_merge_list_processed_genes'],
                            },
              -rc_name => 'default',
            },

            {
              -logic_name => 'havana_merge',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveMerge',
              -parameters => {
                               ensembl_analysis_base => $self->o('ensembl_analysis_base'),
                               host_secondary => $self->o('ensembl_db','-host'),
                               user_secondary => $self->o('user_r'),
                               password_secondary => $self->o('pass_r'),
                               database_secondary => $self->o('ensembl_db','-dbname'),
                               host_primary => $self->o('vega_db','-host'),
                               user_primary => $self->o('user_r'),
                               password_primary =>$self->o('pass_r'),
                               database_primary => $self->o('vega_db','-dbname'),
                               host_output => $self->o('core_db','-host'),
                               user_output =>$self->o('user_w'),
                               password_output => $self->o('pass_w'),
                               database_output => $self->o('core_db','-dbname'),
                               secondary_include => '',
                               secondary_exclude => '',
                               primary_include => '',
                               primary_exclude => '',

                               # Tagging:  Will be used as suffix for logic names ("_tag") and for
                               # source.  With the default settings, merged genes and transcripts will
                               # get the source "secondary_primary".

                               secondary_tag => 'ensembl',
                               primary_tag => 'havana',

                               # Xrefs:  The format is a comma-separated list of
                               # "db_name,db_display_name,type"

                               primary_gene_xref => 'OTTG,Havana gene,ALT_GENE',
                               primary_transcript_xref => 'OTTT,Havana transcript,ALT_TRANS',
                               primary_translation_xref => 'OTTP,Havana translation,MISC',

                               # as the chunks (and a job per chunk) are created in the step before,
                               # these parameters would define how many jobs per chunk we want, just 1 as we don't want chunks of chunks
                               # and we cannot use the LSF job index on the ehive to create chunks of chunks here anyway
                               njobs => 1, #$self->o('njobs'),
                               job => 1,   #$LSB_JOBINDEX

                               #file => '', this parameter will come from 'chunk_genes_for_merge' output, see FileFactory.pm
                             },
              -rc_name => 'normal_1500',
              -analysis_capacity => $self->o('njobs'),
              -hive_capacity => $self->o('njobs'),
              -max_retry_count => 0,
              -wait_for => ['core_sql_truncates'],
            },

            {
              -logic_name => 'havana_merge_list_processed_genes',
              -module     => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
              -parameters => {
                               'cmd'   => "awk '\$1 == ".'"'."PROCESSED".'"'." {print \$2}' ".$self->o('output_dir')."/*merge-run*.out ".
                               " | sort -u -n > ".$self->o('output_dir').'/'.$self->o('processed_genes_filename')
                             },
              -rc_name => 'default',
              -flow_into => { 1 => ['havana_merge_list_unprocessed_genes'] },
            },

            {
              -logic_name => 'havana_merge_list_unprocessed_genes',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveListUnprocessed',
              -parameters => {
              	               processed_genes_filename => $self->o('processed_genes_filename'),
              	               output_dir => $self->o('output_dir'),
              	               output_file => $self->o('unprocessed_genes_filename'),
                               host_secondary => $self->o('ensembl_db','-host'),
                               user_secondary => $self->o('user_r'),
                               password_secondary => $self->o('pass_r'),
                               database_secondary => $self->o('ensembl_db','-dbname'),
                               secondary_include => '',
                               secondary_exclude => '',
                             },
              -rc_name => 'default',
              #-hive_capacity    => 100,
              -flow_into => { 1 => ['chunk_unprocessed_genes'] },
            },

            {
              -logic_name => 'chunk_unprocessed_genes',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::FileFactory',
              -parameters => {
                               inputfile => $self->o('output_dir').'/'.$self->o('unprocessed_genes_filename'),
                               output_dir => $self->o('output_dir'),
                               output_prefix => $self->o('unprocessed_genes_filename')."_chunk_",
                             },
              -flow_into => { '2->A' => [ 'copy_unprocessed_genes' ],
                              'A->1' => [ 'set_ncrna' ],
                            },
              -rc_name => 'default',
            },

            {
              -logic_name => 'copy_unprocessed_genes',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveCopyGenes',
              -parameters => {
                               copy_genes_path => $self->o('ensembl_analysis_base').'/scripts/genebuild/',
                               copy_genes_script_name => 'copy_genes.pl',

                               # copy_genes.pl script parameters
                               logic => 'ensembl',
                               sourcehost => $self->o('ensembl_db','-host'),
                               sourceuser => $self->o('ensembl_db','-user'),
                               sourceport => $self->o('ensembl_db','-port'),
                               sourcepass => $self->o('ensembl_db','-pass'),
                               sourcedbname => $self->o('ensembl_db','-dbname'),
                               outhost => $self->o('core_db','-host'),
                               outuser => $self->o('core_db','-user'),
                               outpass => $self->o('core_db','-pass'),
                               outdbname => $self->o('core_db','-dbname'),
                               outport => $self->o('core_db','-port'),
                               dnahost => $self->o('ensembl_db','-host'),
                               dnadbname => $self->o('ensembl_db','-dbname'),
                               dnauser => $self->o('ensembl_db','-user'),
                               dnaport => $self->o('ensembl_db','-port'),
                               #file => $self->o('output_dir').$self->o('unprocessed_genes_filename'),
                             },
               -analysis_capacity => 20,
               -hive_capacity => 20,
               -max_retry_count => 0,
            },

            {
              -logic_name => 'set_ncrna',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::SqlCmd',
              -parameters => {
                               db_conn => $self->o('core_db'),
                               sql => [ 'INSERT IGNORE analysis(logic_name) VALUES("ncrna")',
                                        'UPDATE gene g,analysis a SET g.analysis_id=(SELECT analysis_id FROM analysis where logic_name="ncrna")
                                                                  WHERE g.analysis_id=a.analysis_id
                                                                         AND a.logic_name="ensembl"
                                                                         AND g.biotype in (
                                                                                           "miRNA",
                                                                                           "misc_RNA",
                                                                                           "ribozyme",
                                                                                           "rRNA",
                                                                                           "scaRNA",
                                                                                           "snoRNA",
                                                                                           "snRNA",
                                                                                           "sRNA"
                                                                                          )',
                                        'UPDATE transcript t,analysis a SET t.analysis_id=(SELECT analysis_id FROM analysis where logic_name="ncrna")
                                                                   WHERE t.analysis_id=a.analysis_id
                                                                         AND a.logic_name="ensembl"
                                                                         AND t.biotype in (
                                                                                           "miRNA",
                                                                                           "misc_RNA",
                                                                                           "ribozyme",
                                                                                           "rRNA",
                                                                                           "scaRNA",
                                                                                           "snoRNA",
                                                                                           "snRNA",
                                                                                           "sRNA"
                                                                                          )'
                                       ],
                             },
              -flow_into => { 1 => ['set_igtr_analysis_biotypes'] },
            },

            {
              -logic_name => 'set_igtr_analysis_biotypes',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::SqlCmd',
              -parameters => {
                               db_conn => $self->o('core_db'),
                               sql => [ 'UPDATE gene g SET g.biotype=REPLACE(g.biotype,"_","_V_")
                                                                     WHERE (g.description LIKE "%variable%" OR
                                                                            g.description LIKE "%variant%" OR
                                                                            g.description LIKE "%ighv%" OR
                                                                            g.description LIKE "%immunog.%V.%pseudogene%")
                                                                           AND
                                                                           (g.biotype LIKE "IG\_%" OR
                                                                            g.biotype LIKE "TR\_%")
                                         ',
                                         'UPDATE gene g SET g.biotype=REPLACE(g.biotype,"_","_C_")
                                                                     WHERE (g.description LIKE "%constant%")
                                                                           AND
                                                                           (g.biotype LIKE "IG\_%" OR
                                                                            g.biotype LIKE "TR\_%")
                                         ',
                                         'UPDATE gene g SET g.biotype=REPLACE(g.biotype,"_","_J_")
                                                                     WHERE (g.description LIKE "%joining%")
                                                                           AND
                                                                           (g.description NOT LIKE "%constant%")
                                                                           AND
                                                                           (g.biotype LIKE "IG\_%" OR
                                                                            g.biotype LIKE "TR\_%")
                                         ',
                                         'UPDATE gene g SET g.biotype=REPLACE(g.biotype,"_","_D_")
                                                                     WHERE (g.description LIKE "%diversity%")
                                                                           AND
                                                                           (g.biotype LIKE "IG\_%" OR
                                                                            g.biotype LIKE "TR\_%")
                                         ',
                                         'UPDATE transcript t,gene g SET t.biotype=g.biotype
                                                                     WHERE t.gene_id=g.gene_id
                                                                           AND
                                                                           (g.biotype LIKE "IG\_%" OR
                                                                            g.biotype LIKE "TR\_%")
                                                                           AND
                                                                           (t.biotype LIKE "IG\_%" OR
                                                                            t.biotype LIKE "TR\_%")
                                         ',
                                         'UPDATE gene g SET analysis_id=(SELECT analysis_id FROM analysis WHERE logic_name="ensembl_ig_gene")
                                                      WHERE (g.biotype LIKE "IG\_%" OR
                                                             g.biotype LIKE "TR\_%")
                                                            AND
                                                            analysis_id=(SELECT analysis_id FROM analysis WHERE logic_name="ensembl")
                                         ',
                                         'UPDATE transcript SET analysis_id=(select analysis_id FROM analysis WHERE logic_name="ensembl_ig_gene")
                                                            WHERE (biotype LIKE "IG\_%" OR
                                                                   biotype LIKE "TR\_%")
                                                                  AND
                                                                  analysis_id=(SELECT analysis_id FROM analysis WHERE logic_name="ensembl")
                                         ',
                                         'UPDATE gene g SET analysis_id=(SELECT analysis_id FROM analysis WHERE logic_name="havana_ig_gene")
                                                      WHERE (g.biotype LIKE "IG\_%" OR
                                                             g.biotype LIKE "TR\_%")
                                                            AND
                                                            analysis_id=(SELECT analysis_id FROM analysis WHERE logic_name="havana")
                                         ',
                                         'UPDATE transcript SET analysis_id=(select analysis_id FROM analysis WHERE logic_name="havana_ig_gene")
                                                            WHERE (biotype LIKE "IG\_%" OR
                                                                   biotype LIKE "TR\_%")
                                                                  AND
                                                                  analysis_id=(SELECT analysis_id FROM analysis WHERE logic_name="havana")
                                         ',
                                         'UPDATE gene g SET analysis_id=(SELECT analysis_id FROM analysis WHERE logic_name="ensembl_havana_ig_gene")
                                                      WHERE (g.biotype LIKE "IG\_%" OR
                                                             g.biotype LIKE "TR\_%")
                                                            AND
                                                            analysis_id=(SELECT analysis_id FROM analysis WHERE logic_name="ensembl_havana")
                                         ',
                                         'UPDATE transcript SET analysis_id=(select analysis_id FROM analysis WHERE logic_name="ensembl_havana_ig_gene")
                                                            WHERE (biotype LIKE "IG\_%" OR
                                                                   biotype LIKE "TR\_%")
                                                                  AND
                                                                  analysis_id=(SELECT analysis_id FROM analysis WHERE logic_name="ensembl_havana")
                                         ',
                                         'UPDATE gene g SET analysis_id=(SELECT analysis_id FROM analysis WHERE logic_name="proj_ensembl_ig_gene")
                                                      WHERE (g.biotype LIKE "IG\_%" OR
                                                             g.biotype LIKE "TR\_%")
                                                            AND
                                                            analysis_id=(SELECT analysis_id FROM analysis WHERE logic_name="proj_ensembl")
                                         ',
                                         'UPDATE transcript SET analysis_id=(select analysis_id FROM analysis WHERE logic_name="proj_ensembl_ig_gene")
                                                            WHERE (biotype LIKE "IG\_%" OR
                                                                   biotype LIKE "TR\_%")
                                                                  AND
                                                                  analysis_id=(SELECT analysis_id FROM analysis WHERE logic_name="proj_ensembl")
                                         ',
                                         'UPDATE gene g SET analysis_id=(SELECT analysis_id FROM analysis WHERE logic_name="proj_havana_ig_gene")
                                                      WHERE (g.biotype LIKE "IG\_%" OR
                                                             g.biotype LIKE "TR\_%")
                                                            AND
                                                            analysis_id=(SELECT analysis_id FROM analysis WHERE logic_name="proj_havana")
                                         ',
                                         'UPDATE transcript SET analysis_id=(select analysis_id FROM analysis WHERE logic_name="proj_havana_ig_gene")
                                                            WHERE (biotype LIKE "IG\_%" OR
                                                                   biotype LIKE "TR\_%")
                                                                  AND
                                                                  analysis_id=(SELECT analysis_id FROM analysis WHERE logic_name="proj_havana")
                                         ',
                                         'UPDATE gene g SET analysis_id=(SELECT analysis_id FROM analysis WHERE logic_name="proj_ensembl_havana_ig_gene")
                                                      WHERE (g.biotype LIKE "IG\_%" OR
                                                             g.biotype LIKE "TR\_%")
                                                            AND
                                                            analysis_id=(SELECT analysis_id FROM analysis WHERE logic_name="proj_ensembl_havana")
                                         ',
                                         'UPDATE transcript SET analysis_id=(select analysis_id FROM analysis WHERE logic_name="proj_ensembl_havana_ig_gene")
                                                            WHERE (biotype LIKE "IG\_%" OR
                                                                   biotype LIKE "TR\_%")
                                                                  AND
                                                                  analysis_id=(SELECT analysis_id FROM analysis WHERE logic_name="proj_ensembl_havana")
                                         '
                                       ],
                             },
              -max_retry_count => 0,
              -flow_into => { 1 => ['list_toplevel_for_vega_checks_after'] },
            },

            {

              -logic_name => 'list_toplevel_for_vega_checks_after',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::JobFactory',
              -parameters => {
                               db_conn => $self->o('core_db'),
                               inputquery => 'SELECT sr.name FROM seq_region sr, seq_region_attrib sra, attrib_type at WHERE sr.seq_region_id = sra.seq_region_id AND sr.name NOT LIKE "LRG\_%" AND sra.attrib_type_id = at.attrib_type_id AND code = "toplevel"',
                               column_names => ['chromosome'],
                             },
              -flow_into => { '2->A' => [ 'vega_checks_after' ],
                              'A->1' => [ 'vega_checks_after_concat' ],
                            },
              -rc_name => 'default',
            },

            {
              -logic_name => 'vega_checks_after_concat',
              -module     => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
              -parameters => {
                               'cmd'   => 'cat '.$self->o('reports_dir').'/vega_checks_after_*.out > '.
                                                 $self->o('reports_dir').'/vega_checks_after.out'
                             },
              -flow_into => { 1 => ['vega_checks_after_report'] },
              -rc_name => 'default',
            },

            {
              -logic_name => 'vega_checks_after',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveVegaChecks',
              -parameters => {
                               dbname => $self->o('core_db','-dbname'),
                               dbhost => $self->o('core_db','-host'),
                               dnadbname => $self->o('ensembl_db','-dbname'),
                               dnadbhost => $self->o('ensembl_db','-host'),
                               coord_system => 'toplevel',
                               path => $self->o('assembly_path'),
                               sql_output => $self->o('output_dir').'/vega_checks_after_#chromosome#.sql',
                               dbtype => '', # can be 'vega' or '' (empty string)
                               port => '3306',
                               user => $self->o('user_w'),
                               pass => $self->o('pass_w'),
                               #chromosome => '',
                               write => 1,
                               affix => 1, # perform the checks by using the biotypes with or without the prefixes and suffixes like weird_, _Ens, _hav, ... ; with affixes by default
                               biotypes_extension => 1,
                               stdout_file => $self->o('reports_dir').'/vega_checks_after_#chromosome#.out',
                               stderr_file => $self->o('reports_dir').'/vega_checks_after_#chromosome#.err',
                             },
              -hive_capacity    => 30,
              -analysis_capacity => 30,
            },

            {
              -logic_name => 'vega_checks_after_report',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::TextfileByEmail',
              -parameters => {
                               email => $self->o('vega_checks_reports_email'),
                               subject => 'AUTOMATED REPORT: merge biotype combinations',
                               text => 'Please find below the list of not allowed gene and transcript biotype combinations AFTER the merge found in the core database '.$self->o('core_db','-dbname').'. Any artifact transcript listed below will be deleted. Please note that any change applied to the list of allowed biotype combinations will take effect in a future release (not the next release).',
                               file => $self->o('reports_dir').'/vega_checks_after.out',
                               command => q{egrep '(Unknown)|(not allowed\.)' | awk '{print $9,$18}' | sort | uniq -c | sort -nr | sed s'/\. run/ (UNKNOWN gene biotype)/g'},
                             },
              -flow_into => { 1 => ['delete_artifacts'] },
              -rc_name => 'default',
            },
            {
              -logic_name => 'delete_artifacts',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveDeleteTranscripts',
              -parameters => {
              	               biotype => 'artifact',
                               dbhost => $self->o('core_db','-host'),
                               dbname => $self->o('core_db','-dbname'),
                               dbuser => $self->o('user_w'),
                               dbpass => $self->o('pass_w'),
                               dbport => $self->o('core_db','-port'),
                               delete_transcripts_path => $self->o('ensembl_analysis_base').'/scripts/genebuild/',
                               delete_genes_path => $self->o('ensembl_analysis_base').'/scripts/genebuild/',
                               delete_transcripts_script_name => 'delete_transcripts.pl',
                               delete_genes_script_name => 'delete_genes.pl',
                               output_path => $self->o('output_dir').'/delete_artifacts/',
                               output_file_name => 'delete_artifacts.out',
                               email => $self->o('vega_checks_reports_email'),
                               from => 'ensembl-genebuild@ebi.ac.uk'
                             },
              -max_retry_count => 0,
              -flow_into => { 1 => ['set_temp_stable_ids'] },
            },

            {
              # make sure that all my transcript have stable IDs so that the CCDS can be added as supporting features later on
              -logic_name => 'set_temp_stable_ids',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::SqlCmd',
              -parameters => {
                               db_conn => $self->o('core_db'),
                               sql => [ "UPDATE transcript SET stable_id=CONCAT('TEMPSID',transcript_id) WHERE stable_id IS NULL" ],
                             },
               -max_retry_count => 3,
               -rc_name => 'default',
               -flow_into => { 1 => ['list_toplevel'] },
            },


            {
              -logic_name => 'list_toplevel',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::JobFactory',
              -parameters => {
                               db_conn => $self->o('core_db'),
                               inputquery => 'SELECT sr.name FROM seq_region sr, seq_region_attrib sra, attrib_type at WHERE sr.seq_region_id = sra.seq_region_id AND sr.name NOT LIKE "LRG\_%" AND sra.attrib_type_id = at.attrib_type_id AND code = "toplevel"',
                               column_names => ['chr'],
                             },
               -flow_into => { '2->A' => ['alternative_atg_attributes'],

                              'A->1' => WHEN ('#process_ccds#' => ['ccds_sql_updates'],
                                        ELSE                      ['set_frameshift_transcript_attributes']),
                            },
              -rc_name => 'default',
            },

            {
              -logic_name => 'alternative_atg_attributes',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
              -parameters => {
                               cmd => 'perl '.$self->o('ensembl_analysis_base').'/scripts/Merge/look_for_upstream_atg.pl'.
                                      ' -dbuser '.$self->o('user_w').
                                      ' -dbpass '.$self->o('pass_w').
                                      ' -dbhost '.$self->o('core_db','-host').
                                      ' -dbport '.$self->o('core_db','-port').
                                      ' -dbname '.$self->o('core_db','-dbname').
                                      ' -dna_user '.$self->o('user_r').
                                      ' -dna_host '.$self->o('core_db','-host').
                                      ' -dna_port '.$self->o('core_db','-port').
                                      ' -dna_dbname '.$self->o('core_db','-dbname').
                                      ' -upstream_dist 200'.
                                      ' -chromosomes #chr#'.
                                      ' -genetypes protein_coding'.
                                      ' -coord_system toplevel'.
                                      ' -path '.$self->o('assembly_path')
                             },
               -analysis_capacity => 25,
               -hive_capacity => 25,
               -max_retry_count => 2,
               -rc_name => 'normal_1500',
               -flow_into => { 1 => WHEN ('!#process_ccds#' => ['set_canonical_transcripts_without_ccds'])},
            },

            {
              -logic_name => 'set_canonical_transcripts_without_ccds',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
              -parameters => {
                               cmd => 'perl '.$self->o('ensembl_analysis_base').'/../ensembl/misc-scripts/canonical_transcripts/select_canonical_transcripts.pl'.
                                      ' -dbuser '.$self->o('user_w').
                                      ' -dbpass '.$self->o('pass_w').
                                      ' -dbhost '.$self->o('core_db','-host').
                                      ' -dbport '.$self->o('core_db','-port').
                                      ' -dbname '.$self->o('core_db','-dbname').
                                      ' -seq_region_name #chr#'.
                                      ' -coord toplevel'.
                                      ' -write'
                             },
               -analysis_capacity => 25,
               -hive_capacity => 25,
               -max_retry_count => 2,
               -rc_name => 'normal_1500',
            },

            {
              -logic_name => 'ccds_sql_updates',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::SqlCmd',
              -parameters => {
                               db_conn => $self->o('core_db'),
                               sql => [ 'UPDATE gene SET biotype="protein_coding" WHERE biotype="ccds_gene"',
                                        'UPDATE transcript SET biotype="protein_coding" WHERE biotype="ccds_gene"',
                                        'INSERT IGNORE analysis(created,logic_name) VALUES(now(),"ccds")',
                                        'UPDATE dna_align_feature SET analysis_id=(SELECT analysis_id FROM analysis WHERE logic_name="ccds")
                                                                WHERE analysis_id=(SELECT analysis_id FROM analysis WHERE logic_name="ccds_gene")
                                                                      OR dna_align_feature.hit_name LIKE "ccds%"',
                                        'UPDATE gene SET source="ensembl" WHERE source="ccds"',
                                        'DELETE FROM analysis WHERE logic_name="ccds_gene"',
                                       ],
                             },
              -max_retry_count => 0,
              -flow_into => { 1 => ['prepare_lincrnas'] },
            },

            {
              -logic_name => 'prepare_lincrnas',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::SqlCmd',
              -parameters => {
                               db_conn => $self->o('core_db'),
                               sql => [ "UPDATE gene SET biotype = 'new_lincRNA' WHERE biotype = 'lincRNA'" ],
                             },
               -max_retry_count => 3,
               -rc_name => 'default',
               -flow_into => { 1 => ['transfer_lincrnas'] },
            },

            {
              -logic_name => 'transfer_lincrnas',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
              -parameters => {
                               cmd => 'perl '.$self->o('ensembl_analysis_base').'/scripts/Merge/transfer_lincRNAs_to_merged_gene_set.pl'.
                                      ' -dbname '.$self->o('prevcore_db','-dbname').
                                      ' -dbhost '.$self->o('prevcore_db','-host').
                                      ' -dbport '.$self->o('prevcore_db','-port').
                                      ' -dbuser '.$self->o('user_r').
                                      ' -newdbname '.$self->o('core_db','-dbname').
                                      ' -newdbhost '.$self->o('core_db','-host').
                                      ' -newdbuser '.$self->o('user_w').
                                      ' -newdbpass '.$self->o('pass_w').
                                      ' -vegadbname '.$self->o('vega_db','-dbname').
                                      ' -vegadbhost '.$self->o('vega_db','-host').
                                      ' -vegadbport '.$self->o('vega_db','-port').
                                      ' -vegadbuser '.$self->o('user_r').
                                      ' -coordsystem chromosome'.
                                      ' -path '.$self->o('assembly_path').
                                      ' -write '.
                                      ' -verbose'
                             },
               -max_retry_count => 0,
               -rc_name => 'normal_1500',
               -flow_into => { 1 => ['set_lincrna_biotypes'] },
            },

            {
              -logic_name => 'set_lincrna_biotypes',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::SqlCmd',
              -parameters => {
                               db_conn => $self->o('core_db'),
                               sql => [ "UPDATE gene SET biotype = 'lincRNA' WHERE biotype = 'new_lincRNA'" ],
                             },
               -max_retry_count => 3,
               -rc_name => 'default',
               -flow_into => { 1 => ['backup_dump_core_db_after_merge'] },
            },

            {
              -logic_name => 'set_frameshift_transcript_attributes',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
              -parameters => {
                               cmd => 'perl '.$self->o('ensembl_analysis_base').'/../ensembl/misc-scripts/frameshift_transcript_attribs.pl'.
                                      ' -dbuser '.$self->o('user_w').
                                      ' -dbpass '.$self->o('pass_w').
                                      ' -dbhost '.$self->o('core_db','-host').
                                      ' -dbport '.$self->o('core_db','-port').
                                      ' -dbpattern '.$self->o('core_db','-dbname')
                             },
               -analysis_capacity => 25,
               -hive_capacity => 25,
               -max_retry_count => 2,
               -rc_name => 'normal_4600',
               -flow_into => { 1 => ['set_repeat_types'] },
            },

            {
              -logic_name => 'set_repeat_types',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
              -parameters => {
                               cmd => 'perl '.$self->o('ensembl_analysis_base').'/../ensembl/misc-scripts/repeats/repeat-types.pl'.
                                      ' -user '.$self->o('user_w').
                                      ' -pass '.$self->o('pass_w').
                                      ' -host '.$self->o('core_db','-host').
                                      ' -port '.$self->o('core_db','-port').
                                      ' -dbpattern '.$self->o('core_db','-dbname')
                             },
               -analysis_capacity => 25,
               -hive_capacity => 25,
               -max_retry_count => 2,
               -rc_name => 'default',
               -flow_into => { 1 => ['load_external_db_ids_and_optimise_af_tables'] },
            },

            {
              -logic_name => 'load_external_db_ids_and_optimise_af_tables',
              -module => 'Bio::EnsEMBL::Hive::RunnableDB::SystemCmd',
              -parameters => {
                               cmd => 'perl '.$self->o('ensembl_analysis_base').'/scripts/genebuild/load_external_db_ids_and_optimize_af.pl'.
                                      ' -output_path '.$self->o('output_dir').'/optimise'.
                                      ' -uniprot_filename '.$self->o('uniprot_file').
                                      ' -dbuser '.$self->o('user_w').
                                      ' -dbpass '.$self->o('pass_w').
                                      ' -dbhost '.$self->o('core_db','-host').
                                      ' -dbname '.$self->o('core_db','-dbname').
                                      ' -prod_dbuser '.$self->o('user_r').
                                      ' -prod_dbhost '.$self->o('production_db','-host').
                                      ' -prod_dbname '.$self->o('production_db','-dbname').
                                      ' -prod_dbport '.$self->o('production_db','-port').
                                      ' -verbose'
                             },
               -analysis_capacity => 25,
               -hive_capacity => 25,
               -max_retry_count => 2,
               -rc_name => 'normal_12000',
            },
            
            {
              -logic_name => 'backup_dump_core_db_after_merge',
              -module => 'Bio::EnsEMBL::Analysis::Hive::RunnableDB::HiveCreateDatabase',
              -parameters => {
                                create_type => 'backup',
                                source_db => $self->o('core_db'),
                                backup_name => $self->o('backup_dump_core_db_after_merge_filename'),
                                pass_w => $self->o('pass_w'),
                                user_w => $self->o('user_w'),
                                output_path => $self->o('output_dir'),
                             },


            },
  ];
}

sub pipeline_wide_parameters {
    my ($self) = @_;

      return {
            # Inherit other stuff from the parent class
                %{$self->SUPER::pipeline_wide_parameters()},
                'process_ccds' => $self->o('process_ccds'),
      };
}

1;
