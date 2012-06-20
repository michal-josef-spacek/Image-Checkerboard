# Pragmas.
use strict;
use warnings;

# Modules.
use inc::Module::Install;

# Definition.
abstract 'Perl class for image checkerboards creating.';
author 'Michal Špaček <skim@cpan.org>';
license 'bsd';
name 'Image-Checkerboard';
requires 'Cwd' => 0;
requires 'English' => 0;
requires 'Exporter' => 0;
requires 'List::MoreUtils' => 0;
requires 'Readonly' => 0;
requires 'perl' => '5.6.2';
resources 'bugtracker' => 'https://rt.cpan.org/Public/Dist/Display.html'.
	'?Name=Image-Checkerboard';
resources 'homepage' => 'https://github.com/tupinek/Image-Checkerboard';
resources 'repository' => 'git://github.com/tupinek/Image-Checkerboard';
test_requires 'English' => 0;
test_requires 'Test::More' => 0;
test_requires 'Test::Pod' => 0;
test_requires 'Test::Pod::Coverage' => 0;
tests_recursive;
version '0.01';

# Run.
WriteAll();
