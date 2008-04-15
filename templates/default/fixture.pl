#!/usr/bin/perl

use strict;
use warnings;

use lib "lib";

use MyApp;

use YAML::XS;
use Data::Dumper;

sub p ($) { print Dumper shift };

my $c = MyApp->prepare;

my $fixture = Load( do { local $/; <DATA> } );

foreach my $key (keys %{$fixture}) {
    $c->model($key)->delete;
    foreach my $data (@{ $fixture->{$key} }) {
        my $f = $c->model($key)->find_or_create($data);
        $f->set_columns($data);
        $f->insert_or_update();
    };
}

__END__
---
DBIC::Address:
  - id: 1
    uid: uniqueid
    url: http://google.com/
    created_at: 2008-03-03 01:00:00
