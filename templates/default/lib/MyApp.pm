package MyApp;
use strict;
use warnings;

use Catalyst::Runtime '5.70';
use Catalyst qw/
	+MyApp::Util

	ConfigLoader

	Session
	Session::State::Cookie
	Session::Store::FastMmap

	Authentication
	Authentication::Credential::Password
	Authentication::Credential::OpenID

	FormValidator::Simple
	FormValidator::Simple::Auto
	FillInForm

	I18N
	Unicode
/;

our $VERSION = '0.01';

__PACKAGE__->setup(
	do {
		my @plugins;
		push @plugins, 'DebugScreen' if $ENV{CATALYST_DEBUG};
		@plugins;
	}
);

sub begin : Private {
	my ($self, $c) = @_;
}

sub auto : Private {
	my ($self, $c) = @_;
}

1;
