#!/usr/bin/perl

use strict;
use warnings;

use lib 'lib';

use MyApp;
use MyApp::Schema;

use SQL::Translator;

use Data::Dumper;
sub p ($) { print Dumper shift }

$ENV{DBIC_TRACE} = 1;

my $c      = MyApp->prepare;
my $schema = $c->model->result_source->schema;

$schema->create_ddl_dir(
	[ qw/MySQL/ ],
	$schema->VERSION,
	'sql_dir',
);

$schema->upgrade;


