use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Mojolicious::Plugin::Libravatar',
  VERSION_FROM => 'lib/Mojolicious/Plugin/Libravatar.pm',
  AUTHOR       => 'A Good Programmer <nospam@cpan.org>',
  PREREQ_PM    => {'Mojolicious' => '3.50'},
  test         => {TESTS => 't/*.t'}
);
