package Eg::client;

require 5.005;
require Exporter;

=head1 NAME

Eg::client - Access to the client subsystem of Sac;

=head1 SYNOPSIS

    use Eg::client;

    $client = new Eg::client;

=head1 DESCRIPTION

	client       varchar(8)
	prefix       bpchar(2)
	name         varchar(60)
	contact      varchar(30)
	address      varchar(200)
	phone        varchar(15)
	email        varchar(80)

=cut

@ISA = qw(Exporter);
@EXPORT = qw();
$VERSION = $VERSION = '1.01';

use strict;
use Eg::db;
use Eg::util;

sub new {
	my($client);
	bless $client;

	return undef unless @_;
	my($id) = @_;
	
	$client->{id} = $id;
	return $client;
}

sub create {
	my($dbh) = new Eg::db;
	my(@row);

	die("insert into client(...) ");
	my($sth) = $dbh->prepare("insert into client(...) v nextval('invoice_invoice_seq')");
	$sth->execute();
	@row = $sth->fetchrow_array;

	return $row[0];
}

sub save {
	my($invoice) = @_;

	if ($invoice->{update}) {
		update($invoice);
	} else {
		insert($invoice)
	}
}

sub list {
	my($client) = @_;

	my($dbh) = new Eg::db;
	my($sth);

	if ($client) {
		$sth = $dbh->prepare("select * from client where client = ?");
		$sth->execute($client);
	} else {
		$sth = $dbh->prepare("select * from client");
		$sth->execute();
	}

	return $sth;
}

sub prefix {
	#                table     field     key       search
	return sql_fetch('client', 'prefix', 'client', @_);
}

sub name {
	#                table     field     key       search
	return sql_fetch('client', 'name', 'client', @_);
}

sub address {
	#                table     field      key       search
	return sql_fetch('client', 'address', 'client', @_);
}

sub update {
	my(%arg) = @_;

	
	die ("client::update not supported");

	my($dbh) = new Eg::db;
	my($sql) = "update from client ...";
	my($sth) = $dbh->prepare(<<"EOF");
        update from client set client = ?, name = ?, phone = ?, email, address)
	values(?,?,?,?,?)
EOF
	
	return $sth->execute(
		$arg{client},
		$arg{name} || '',
		$arg{phone} || '',
		$arg{email} || '',
		$arg{address} || '');
}

sub insert {
	my(%arg) = @_;

	my($dbh) = new Eg::db;
	my($sth) = $dbh->prepare(<<"EOF");
        insert into client (client, prefix, name, phone, email, address)
	values(?,?,?,?,?,?)
EOF

	my($client) = $arg{client};
	
	return $sth->execute(
		$client,
		$arg{prefix} || lc(substr($client,0,2)),
		$arg{name} || '',
		$arg{phone} || '',
		$arg{email} || '',
		$arg{address} || '');
}

sub delete {
	my($client) = @_;
	die "delete not yet supported.\n";

	my($dbh) = new Eg::db;
	my($sth) = $dbh->prepare("delete from client where client = ?");

	return $sth->execute($client);
}

#===========================================================================
# Create/destroy database methods
#===========================================================================
sub create_db {
	sql_assert(<<"EOF");
CREATE TABLE "client" (
        "client"	character varying(8),
        "prefix"	character(2),
        "name"		character varying(60),
        "contact"	character varying(30),
        "address"	character varying(200),
        "phone"		character varying(15),
        "email"		character varying(80));
EOF

	sql_assert('create UNIQUE INDEX client_index on client(client)');
#	sql_assert('REVOKE ALL on "client" from PUBLIC;');
#	sql_assert('GRANT ALL on "client" to "nobody";');
}

sub destroy_db {
	sql_assert("DROP TABLE client;");
	sql_assert("DROP INDEX client_index;");
}

1;
