package ComGen::Controller::Login;

use strict;
use warnings;
use parent 'Catalyst::Controller';

sub index :Private {
	my ($self, $c) = @_;

	if ($c->authenticate_openid) {
		$c->detach( '/login/redirect' );
	}
}

sub logout :Global {
	my ($self, $c) = @_;

	$c->logout;
	$c->forward('redirect');
}

sub redirect :Private {
	my ($self, $c) = @_;

	if ($c->user && $c->user->is_first) {
		$c->res->redirect( $c->uri_for( '/account' ) );
	} else {
		$c->res->redirect( $c->uri_for( $c->flash->{redirect} || '/' ) );
	}
}

1;
