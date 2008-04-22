package MyApp::Controller::API;

use strict;
use warnings;
use base 'Catalyst::Controller';


sub end : Private {
	my ($self, $c) = @_;

	my $api = $c->stash->{api} || {};
	$api->{result} ||= '' unless defined $api->{result};
	$api->{error}  ||= '' unless defined $api->{error};
	$c->stash->{api} = $api;

	$c->stash->{fillform} = 0;

	$c->forward( $c->view('JSON') );
}



1;
