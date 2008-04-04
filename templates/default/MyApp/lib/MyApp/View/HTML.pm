package MyApp::View::HTML;

use strict;
use base 'Catalyst::View::MicroMason';

__PACKAGE__->config(
    # -Filters      : to use |h and |u
    # -ExecuteCache : to cache template output
    # -CompileCache : to cache the templates
    Mixins => [qw( -Filters -CompileCache )], 
);
    
=head1 NAME

MyApp::View::HTML - MicroMason View Component

=head1 SYNOPSIS

In your end action:

    $c->forward('MyApp::View::HTML');

=head1 DESCRIPTION

A description of how to use your view, if you're deviating from the
default behavior.

=head1 AUTHOR


=head1 LICENSE

=cut

1; # magic true value
