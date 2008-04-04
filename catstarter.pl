#!/usr/bin/perl

use strict;
use warnings;

use Pod::Usage;
use Getopt::Long;
use Perl6::Say;

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

#script_rename();
#sub script_rename {
#	my $scripts = [ dir("$dist/script")->children ];
#	foreach my $file (@$scripts) {
#		my $name =  $file->basename;
#		$name =~ s/^$appprefix\_//;
#		my $new  = $file->dir->file($name);
#		move $file, $new;
#	}
#}

sub copy_templates_to_dist {
	my ($template_dir, $dist, $opts) = @_;
	my $rule      = $opts->{rule};
	my $vars      = $opts->{vars};

	my $mason     = Text::MicroMason->new(qw/ -ServerPages -AllowGlobals /);
	$mason->set_globals(%$vars);

	$template_dir = dir($template_dir)->absolute;;
	$dist         = dir($dist);

	$template_dir->recurse( callback => sub {
		my ($file) = @_;

		my $path = $file->relative($template_dir);

		if (!$file->is_dir) {
			for my $key (keys %$rule) {
				$path =~ s/$key/$rule->{$key}/ge;
			}
			$path =~ s/^$template_dir/$dist/;
			$path = file($path);

			my $target = $dist->file($path);

			$target->dir->mkpath(1);
			say "$target <- $file";
			copy($file, $target);

			my $content = $target->slurp;
			for my $key (keys %$rule) {
				$content =~ s/$key/$rule->{$key}/ge;
			}
			my $fh = $target->openw;
			print $fh $mason->execute(text => $content);
			$fh->close;
		}
	} );
}


my $module    = shift @ARGV;
my $pkg       = [ split /::/, $module ];
my $dist      = join "-", @$pkg;
my $path      = join( "/", @$pkg ) . ".pm";
my $appprefix = Catalyst::Utils::appprefix($module);

copy_templates_to_dist("./templates/default/", $dist, {
	rule => {
		MyApp => $module,
		myapp => $appprefix,
	},
	vars => {
		'$module'    => $module,
		'$pkg'       => $pkg,
		'$dist'      => $dist,
		'$path'      => $path,
		'$module'    => $module,
		'$appprefix' => $appprefix,
	},
});

__END__


