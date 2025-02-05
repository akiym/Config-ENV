#line 1
package Test::Name::FromLine;

use strict;
use warnings;

our $VERSION = '0.17';

use Test::Builder;
use File::Slurp;
use File::Spec;
use Cwd qw(getcwd);

our $BASE_DIR = getcwd();
our %filecache;

no warnings 'redefine';
my $ORIGINAL_ok = \&Test::Builder::ok;
*Test::Builder::ok = sub {
	$_[2] ||= do {
		my ($package, $filename, $line) = caller($Test::Builder::Level);
		if ($filename) {
			$filename = File::Spec->rel2abs($filename, $BASE_DIR);
			my $file = $filecache{$filename} ||= [ read_file($filename) ];
			my $lnum = $line;
			$line = $file->[$lnum-1];
			$line =~ s{^\s+|\s+$}{}g;
			"L$lnum: $line";
		} else {
			""; # invalid $Test::Builder::Level
		}
	};
	goto &$ORIGINAL_ok;
};


1;
__END__

=encoding utf8

#line 73
