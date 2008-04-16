package MyApp::Controller::Root;

use strict;
use warnings;
use base 'Catalyst::Controller';

__PACKAGE__->config->{namespace} = '';

sub default : Private {
	my ( $self, $c ) = @_;

	# Hello World
	$c->response->body( $c->welcome_message );
}

sub end : ActionClass('RenderView') {
	my ( $self, $c ) = @_;

	$c->res->header( 'Cache-Control' => 'private' );
	$c->stash->{class} = [ split '/', $c->action ]->[0];

	if (!$ENV{CATALYST_DEBUG} && scalar(@{ $c->error }) ) {
		$c->stash->{template} = 'errors/500.pl.html';
		$c->error(0);
	}
}

1;
