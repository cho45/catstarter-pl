package MyApp::Schema::User;

use strict;
use warnings;

use DateTime::Format::MySQL;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('users');
__PACKAGE__->add_columns(
	id => {
		data_type => 'INT',
		extra     => {
			unsigned => 1,
		},
	},

	name => {
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
__PACKAGE__->add_unique_constraint("uid", ["uid"]);

__PACKAGE__->inflate_column(
	$_ => {
		inflate => sub { DateTime::Format::MySQL->parse_datetime(shift)->set_time_zone($XG::Schema::TZ) },
		deflate => sub { DateTime::Format::MySQL->format_datetime(shift->set_time_zone($XG::Schema::TZ)) },
	},
) for qw/created_at logged_in_at/;

sub insert {
	my $self = shift;

	my $now = DateTime->now;
	$self->created_date($now);

	$self->next::method(@_);
}

1;
