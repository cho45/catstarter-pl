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

sub loc {
	my ($c, $id, @args) = @_;
	my $ret = $c->localize($id, @args);
	$ret;
}

sub finalize {
	my $c = shift;
	return $c->NEXT::finalize(@_) if defined $c->stash->{fillform} and !$c->stash->{fillform};

	my $fillform = $c->form->has_error ? $c->req->params : $c->stash->{fillform};

	if ( $c->isa('Catalyst::Plugin::FormValidator') ) {
		$c->fillform($fillform) if $c->form->has_missing || $c->form->has_invalid || $c->stash->{fillform};
	}

	return $c->NEXT::finalize(@_);
}

1;
__END__



