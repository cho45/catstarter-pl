package MyApp::Schema::ExternalID;

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

	user => {
		data_type => 'INT',
		extra     => {
			unsigned => 1,
		},
	},

	provider => {
		data_type => 'VARCHAR(255)',
	},

	name => {
		data_type => 'VARCHAR(255)',
	},
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint("name", ["name"]);
__PACKAGE__->belongs_to( user => 'MyApp::Schema::User' );

sub auto_create :ResultSet {
	my ($rs, $id, @rest) = @_;

	my $display_name = $rest[0]->{url}; # OpenID

	$rs->create({
		provider => "openid",
		name     => $id,
	});
}

1;
