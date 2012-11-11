use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Mojolicious::Plugin::Libravatar',
    VERSION_FROM => 'lib/Mojolicious/Plugin/Libravatar.pm',
    AUTHOR       => 'William Travis Holton <heytrav@cpan.org>',
    PREREQ_PM    => {
        'Mojolicious'     => '3.50',
        'Libravatar::URL' => 0,
    },
    test => { TESTS => 't/*.t' }
);
