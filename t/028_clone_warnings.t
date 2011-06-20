use strict;
use DBI;
use Test::More tests => 1;

$SIG{__WARN__} = sub {
    ok(undef,'Warnings during clone');
    exit(1);
};

my $dbh = DBI->connect('DBI:Mock:', 'joe', 'pass');;
my $dbh2 = $dbh->clone;
ok(1, 'Warnings during clone');
