package MyApp::Util;

use strict;
use warnings;

sub form_message {
	my ($c, @args) = @_;
	my $messages = $c->form_messages(@args);

	if ($messages && ref($messages) eq 'ARRAY') {
		my $message = $messages->[0];
		# for I18N
		if ($message =~ /^\{\{(.+)\}\}$/) {
			$message = $c->loc($1);
		}
		return sprintf($c->config->{validator}{_message_format} || "%s", $message);
	}

	$messages;
}

1;
__END__



