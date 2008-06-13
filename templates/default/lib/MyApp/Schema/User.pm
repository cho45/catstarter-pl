package MyApp::Schema::User;

use strict;
use warnings;

use DateTime::Format::MySQL;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/UTF8Columns PK::Auto Core/);
__PACKAGE__->table('users');
__PACKAGE__->add_columns(
	id => {
		data_type => 'INT',
		is_auto_increment => 1,
		extra     => {
			unsigned => 1,
		},
	},

	nick => {
		data_type => 'VARCHAR(255)',
	},

	username => {
		data_type => 'VARCHAR(255)',
	},

	password => {
		data_type => 'VARCHAR(255)',
	},

	icon => {
		data_type => 'TEXT',
	},

	logged_in_at => {
		data_type => 'DATETIME',
	},

	created_at => {
		data_type => 'DATETIME',
	},
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint("nick", ["nick"]);

__PACKAGE__->inflate_column(
	$_ => {
		inflate => sub { DateTime::Format::MySQL->parse_datetime(shift)->set_time_zone($MyApp::Schema::TZ) },
		deflate => sub { DateTime::Format::MySQL->format_datetime(shift->set_time_zone($MyApp::Schema::TZ)) },
	},
) for qw/created_at logged_in_at/;

sub insert {
	my $self = shift;

	my $now = DateTime->now;
	$self->created_at($now);

	$self->next::method(@_);
}

sub auto_create :ResultSet {
	my ($rs, $id, @rest) = @_;

	my $display_name = $rest[0]->{display}; # OpenID

	$rs->create({
		nick     => $id,
		username => $display_name,
	});
}

1;
