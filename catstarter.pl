#!/usr/bin/perl

use strict;
use warnings;

use Pod::Usage;
use Getopt::Long;
use Perl6::Say;
use autobox;
use autobox::Core;

use ExtUtils::MakeMaker qw(prompt);

use Text::MicroMason;
use Path::Class qw/dir file/;
use File::Copy;
use File::HomeDir;
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

# push @ARGV, "Test";

exit unless @ARGV == 1;

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

sub execute_startup {
	my ($dist) = @_;

	my $startup = dir($dist)->file("startup.sh")->absolute;
	if (-e $startup) {
		cd $dist, sub {
			!system "/bin/sh $startup" or die $?;
		};
		$startup->remove();
	}
}

sub select_templates {
	my $global = file(__FILE__)->dir->absolute->subdir('templates');
	my $local  = dir(File::HomeDir->my_home)->subdir('.catstarter', 'templates');
	say "Global templates: $global";
	say "Local templates: $local";

	my $templates = [];

	for my $dir ($local, $global) {
		(-e "$dir") || next;

		my $tmpls = [];
		for my $f ($dir->children) {
			next unless $f->is_dir;

			$f = file($f);

			if ($f->basename eq 'default') {
				# $tmpls->unshift(file($f));
				unshift @$tmpls, file($f);
			} else {
				$tmpls->push(file($f));
			}
		}

		$templates->push(@$tmpls);
	}

	for (1..@$templates) {
		my $template = $templates->[$_-1];
		my $dispname = $template->basename;
		$dispname .= ' (.catstarter)' if $template =~ /\.catstarter/;
		say sprintf "[%d]: %s", $_, $dispname;
	}
	my $selected = prompt('Select:', '1');

	$templates->[$selected-1]->cleanup;
}


my $template = select_templates();
if ($template) {
	say "Selected $template";
} else {
	say "No template selected";
	exit 1;
}


my $module    = [ @ARGV ]->shift;
my $pkg       = $module->split("::");
my $dist      = $pkg->join("-");
my $path      = $pkg->join("/") . ".pm";
my $appprefix = Catalyst::Utils::appprefix($module);

copy_templates_to_dist($template, $dist, {
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

execute_startup($dist);

__END__

=head1 NAME

catstarter.pl - Create Catalyst app skelton.

=head1 SYNOPSIS

  $ catstarter.pl MyApp

=head1 DESCRIPTION

  Execute startup.sh under template root directory after creating target app.

=cut

