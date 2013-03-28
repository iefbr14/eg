package Eg::util;

require 5.005;
require Exporter;

=head1 NAME

Eg::util - Utility fuctions

=head1 SYNOPSIS

    use Eg::util;

=head1 DESCRIPTION

=cut

@ISA = qw(Exporter);
@EXPORT = qw(prompt today validate sql_assert sql_fetch);
$VERSION = $VERSION = '1.01';

use strict;
use Eg::db;

sub prompt {
	my($prompt, $default) = @_;
	local($|) = 1;

	$default ||= '';

	my($disp) = $default . ("\b" x length($default));
	printf "%-15s $disp", "$prompt:";
	if (defined($_ = <STDIN>)) {
		chomp;

		$_ = $default if $_ eq '';

		return $_;
	}
	print "^D -- Bye --\n";
	exit 0;
}

my($Today) = '';
sub today {
	return $Today if $Today;

	$Today = `date +%Y-%m-%d`;
	chomp($Today);
	return $Today;
}

sub validate {
	# write type validation code.
}


sub sql_assert {
	my($sql) = @_;
	my($dbh) = new Eg::db;
	
	my($sth) = $dbh->prepare($sql);
	if ($sth->execute()) {
		return;
	}
	warn "Can't run $sql ($!)\n";
}

sub sql_fetch {
	my($table, $field, $key, $value) = @_;

	my($dbh) = new Eg::db;
	my($sth) = $dbh->prepare("select $field from $table where $key = ?");
	my(@row);

	eval {
		$sth->execute($value);
		@row = $sth->fetchrow_array();
	}; if ($@) {
		warn "No field $field in table $table $@\n";
		return undef;
	}
	
	return $row[0];
}

1;
