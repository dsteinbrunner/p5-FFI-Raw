package CompileTest;

use strict;
use warnings;

use Config;
use ExtUtils::CBuilder;
use Text::ParseWords qw(shellwords);

sub compile {
	my ($src_file) = @_;

	my $b = ExtUtils::CBuilder -> new;

	my $obj_file = $b -> compile(
		source => $src_file,
		extra_compiler_flags => '-std=gnu99'
	);

	return $b -> link(objects => $obj_file)
		unless ($^O eq 'MSWin32');

	$src_file =~ s/\.c$//;
	$src_file =~ s/^.*(\/|\\)//;

	my $lddlflags = $Config{lddlflags};
	$lddlflags =~ s{\\}{/}g;
	system $Config{cc}, shellwords($lddlflags), -o => "t/$src_file.dll", "-Wl,--export-all-symbols", $obj_file;

	return "t/$src_file.dll";
}

1;
