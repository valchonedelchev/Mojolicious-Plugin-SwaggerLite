use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Mojolicious::Plugin::SwaggerLite',
  VERSION_FROM => 'lib/Mojolicious/Plugin/SwaggerLite.pm',
  AUTHOR       => 'Valcho Nedelchev <weby@cpan.org>',
  PREREQ_PM    => {'Mojolicious' => '6.63'},
  test         => {TESTS => 't/*.t'}
);
