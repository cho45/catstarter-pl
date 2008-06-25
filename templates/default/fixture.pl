#!/usr/bin/env perl

use strict;
use warnings;

use lib "lib";

use PlantAPIServer;

use YAML::XS qw/LoadFile/;
use Path::Class;
use Hash::Merge;

use Data::Dumper;
sub p ($) { print Dumper shift };

my $c = PlantAPIServer->prepare;

my $fixture = {};

for my $file (dir(qw/t fixtures/)->children) {
	$fixture = Hash::Merge::merge($fixture, LoadFile($file));
}

foreach my $key (keys %{$fixture}) {
	$c->model($key)->delete;
	foreach my $data (@{ $fixture->{$key} }) {
		my $f = $c->model($key)->find_or_create($data);
		$f->set_columns($data);
		$f->insert_or_update();
	};
}

1;
