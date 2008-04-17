package MyApp::Util;

use strict;
use warnings;

sub form_message {
	my ($c, @args) = @_;
	my $messages = $c->form_messages(@args);

	if ($messages && ref($messages) eq 'ARRAY') {
		return $messages->[0];
	}

	$messages;
}

1;
__END__



