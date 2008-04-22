package MyApp::View::JSON;

use strict;
use base 'Catalyst::View::JSON';

use JSON::XS ();

sub new {
	my $self = shift->NEXT::new(@_);

	my $dumper = JSON::XS->new->latin1;
	$self->json_dumper(sub { $dumper->encode($_[0]) });

	$self;
}

1;
