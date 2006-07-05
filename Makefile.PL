use strict;
use warnings;
use inc::Module::Install;

name 'Mixin-EMKit';
author 'Hans Dieter Pearcey <hdp@cpan.org>';
all_from;

build_requires 'Test::More' => 0;

requires 'Sub::Exporter'           => 0;
requires 'Email::MIME::Kit'        => 0;
requires 'File::ShareDir'          => 0;
requires 'File::Spec'              => 0;

auto_install;
WriteAll;
