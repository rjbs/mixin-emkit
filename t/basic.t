#!perl

use strict;
use warnings;

package T;

use Mixin::EMKit;

sub kit_root_dir { './t' }

package main;

use Test::More 'no_plan';

my $obj = bless { flavor => 'blueberry' } => 'T';

is $obj->kit_dir('foo'), 't/foo', 'correct kit dir';
is $obj->kit_dir('bar'), 't/bar.mkit', 'appends .mkit when needed';

my $kit = $obj->kit('bar');
isa_ok $kit, 'Email::MIME::Kit';

like eval { $kit->assemble->as_string }, qr/It is blueberry flavored/,
  '$self curried in';
is $@, "", "no errors in assembly";
