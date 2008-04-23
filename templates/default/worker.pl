#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use YAML;
sub p ($) { print Dump shift }

use lib 'lib';
use MyApp::Schema;

my $config = YAML::LoadFile("ttm.yml");

my $schema = MyApp::Schema->connect(@{ $config->{"Model::DBIC"}->{connect_info} });


$schema->resultset("User")->search({});




