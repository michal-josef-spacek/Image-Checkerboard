# Pragmas.
use strict;
use warnings;

# Modules.
use inc::Module::Install;

# Definition.
abstract 'Perl class for image checkerboards creating.';
author 'Michal Spacek <skim@cpan.org>';
license 'bsd';
name 'Image-Checkerboard';
readme_from 'Checkerboard.pm';
requires 'Class::Utils' => 0.06;
requires 'Error::Pure' => 0.17;
requires 'Imager' => 0;
requires 'Imager::Fill' => 0;
requires 'perl' => '5.6.0';
resources 'bugtracker' => 'https://rt.cpan.org/Public/Dist/Display.html'.
	'?Name=Image-Checkerboard';
resources 'homepage' => 'https://github.com/tupinek/Image-Checkerboard';
resources 'repository' => 'git://github.com/tupinek/Image-Checkerboard';
test_requires 'English' => 0;
test_requires 'File::Object' => 0.08;
test_requires 'Test::More' => 0;
test_requires 'Test::NoWarnings' => 0;
test_requires 'Test::Pod' => 0;
test_requires 'Test::Pod::Coverage' => 0;
tests_recursive;
version '0.03';

# Run.
WriteAll();
