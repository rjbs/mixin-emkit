#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Mixin::EMKit' );
}

diag( "Testing Mixin::EMKit $Mixin::EMKit::VERSION, Perl $], $^X" );
