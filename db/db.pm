package Eg::db;

require 5.005;
require Exporter;

=head1 NAME

Eg::db - access to the Eg database

=head1 SYNOPSIS

    use Eg::db;

    Eg::db::default('database');	# use a different database
    $dbh = new Eg::db;

=head1 DESCRIPTION

=cut

@ISA = qw(Exporter);
@EXPORT = qw();
$VERSION = $VERSION = '1.01';
use strict;

my($Dbh);

my($Db) = '';			# dbi interface (see default)
my($Host) = '';			# host where database lives
my($User) = '';			# user to log into as
my($Pass) = '';			# pass for user.

sub new {
	return $Dbh if ($Dbh);

	default('') unless $Db;
	$Dbh = DBI->connect($Db, $User, $Pass);

	# force ISO date format (YYYY-MM-DD)
	my($sth) = $Dbh->prepare("set datestyle to 'ISO';");
	$sth->execute();

	return $Dbh;
}

sub default {
	my($name) = @_;

	if ($Host eq '') {
		$Host = 'acheron.ss.org';
	}

	if ($name eq '') {
		$name = lc('Eg');
		if ($ENV{'Eg_DATABASE'}) {
			$name = $ENV{'Eg_DATABASE'};
		}
	}
	
	$Db = "dbi:Pg:dbname=$name;host=$Host";

}

END {
	$Dbh->disconnect if $Dbh;
}

1;
