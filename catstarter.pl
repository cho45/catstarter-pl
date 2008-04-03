#!/usr/bin/perl

use strict;
use warnings;

use Pod::Usage;
use Getopt::Long;

use Text::MicroMason;
use Path::Class qw/dir file/;
use File::Copy;
use YAML;
use Data::Dumper;
sub p ($) { print Dumper shift }

use Cwd;
sub cd ($&) {
	my ($dir, $block) = @_;
	my $cd = cwd();
	chdir $dir;
	my $ret = $block->();
	chdir $cd;
	return $ret;
}

GetOptions(\my %opts, qw/help/);

$opts{help} && pod2usage(0);

require Catalyst;
require Catalyst::Utils;
require Catalyst::Helper::Lighty;
require Catalyst::View::MicroMason;
require Catalyst::View::JSON;
require Catalyst::Plugin::DebugScreen;
require JSON::XS;

push @ARGV, "Test";

exit unless @ARGV == 1;

my $module    = shift @ARGV;
my $pkg       = [ split /::/, $module ];
my $dist      = join "-", @$pkg;
my $path      = join( "/", @$pkg ) . ".pm";
my $appprefix = Catalyst::Utils::appprefix($module);

#script_rename();

sub script_rename {
	my $scripts = [ dir("$dist/script")->children ];
	foreach my $file (@$scripts) {
		my $name =  $file->basename;
		$name =~ s/^$appprefix\_//;
		my $new  = $file->dir->file($name);
		move $file, $new;
	}
}

sub copy_templates_to_dist {
	my ($template_dir, $dist) = @_;

	$template_dir = dir($template_dir)->absolute;;
	$dist         = dir($dist);

	$template_dir->recurse( callback => sub {
		my ($file) = @_;

		my $path = $file->relative($template_dir);

		if (!$file->is_dir) {
			$path =~ s/MyApp/$module/g;
			$path =~ s/myapp/$appprefix/g;
			$path =~ s/^$template_dir/$dist/;
			$path = file($path);

			my $target = $dist->file($path);

			$target->dir->mkpath(1);
			copy($file, $target);

			p "$file";
			p "$target";
		}
	});
}

copy_templates_to_dist("./templates/default/", "Foo");

__END__


