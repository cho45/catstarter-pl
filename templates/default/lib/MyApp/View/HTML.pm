package MyApp::View::HTML;

use strict;
use base 'Catalyst::View::MicroMason';

__PACKAGE__->config(
	# -ExecuteCache : to cache template output
	# -CompileCache : to cache the templates
	Mixins => [qw(
		-SafeServerPages
		-CompileCache
	)],
);

sub _render {
	my ($self, @args) = @_;

	my $ret = $self->next::method(@args);
	$ret;
}

1;
