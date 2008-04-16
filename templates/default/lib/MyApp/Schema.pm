package MyApp::Schema;

use strict;
use warnings;

use base qw/ DBIx::Class::Schema /;

use DateTime;
use DateTime::TimeZone;
use DateTime::Format::MySQL;

our $TZ = DateTime::TimeZone->new( name => 'Asia/Tokyo' );

our $VERSION = "1";

__PACKAGE__->load_classes();

__PACKAGE__->load_components(qw/ +DBIx::Class::Schema::Versioned /);
__PACKAGE__->upgrade_directory('.');
__PACKAGE__->backup_directory('backups/');

sub backup {
	my ($self) = @_;
}

1;
