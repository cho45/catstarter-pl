#!/usr/bin/env perl

use strict;
use warnings;

use lib "lib";

use YAML::XS qw/LoadFile/;
use Path::Class;
use Hash::Merge;

use Data::Dumper;
sub p ($) { print Dumper shift };

use PlantAPIServer::Schema;

my $config = LoadFile("myapp.yml");
my $schema = PlantAPIServer::Schema->connect(@{ $config->{"Model::DBIC"}->{connect_info} });

my $fixture = {};

for my $file (dir(qw/t fixtures/)->children) {
	next if $file->is_dir;
	$fixture = Hash::Merge::merge($fixture, LoadFile($file));
}

foreach my $key (keys %{$fixture}) {
	$schema->resultset($key)->delete;
	foreach my $data (@{ $fixture->{$key} }) {
		my $f = $schema->resultset($key)->find_or_create($data);
		$f->set_columns($data);
		$f->insert_or_update();
	};
}

1;
