use Test::More;
use DBI;

plan tests => 6;

my $dbr = DBI->install_driver('Mock');

isa_ok( $dbr, 'DBI::dr' );

my $dbh = DBI->connect( 'dbi:Mock:', '', '' );

isa_ok( $dbh, 'DBI::db' );

$dbh->{mock_session} = DBD::Mock::Session->new(
    {
        statement => q|SELECT foo_id FROM foo|,
        results   => [ [ 'foo_id' ], [ 'foo' ] ]
    },
    {
        statement => q|SELECT bar_id FROM bar|,
        results   => [ [qw/bar_id/], [qw/bar/] ]
    },
);

my $sth_one = $dbh->prepare('SELECT foo_id FROM foo');

isa_ok( $sth_one, 'DBI::st' );

note( $sth_one->{Statement} );

my $sth_two = $dbh->prepare('SELECT bar_id FROM bar');

isa_ok( $sth_two, 'DBI::st' );

$sth_one->execute;

is( $sth_one->fetchrow_arrayref->[0], 'foo', 'Results');

$sth_two->execute;
is( $sth_two->fetchrow_arrayref->[0], 'bar', 'Results');    

