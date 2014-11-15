package Image::Checkerboard;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use Error::Pure qw(err);
use Imager;
use Imager::Fill;

# Version.
our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my $self = bless {}, $class;

	# Background color.
	$self->{'bg'} = 'black';

	# Flip flag.
	$self->{'flip'} = 1;

	# Foreground color.
	$self->{'fg'} = 'white';

	# Sizes.
	$self->{'width'} = 1920;
	$self->{'height'} = 1080;

	# Image type.
	$self->{'type'} = 'bmp';

	# Process params.
	set_params($self, @params);

	# Flip stay.
	$self->{'_flip_stay'} = 0;

	# Imager object.
	$self->{'_imager'} = Imager->new(
		'xsize' => $self->{'width'},
		'ysize' => $self->{'height'},
	);

	# Object.
	return $self;
}

# Create image.
sub create {
	my ($self, $path) = @_;

	# Get type.
	my $suffix;
	if (! defined $self->{'type'}) {

		# Get suffix.
		(my $name, undef, $suffix) = fileparse($path, qr/\.[^.]*/ms);
		$suffix =~ s/^\.//ms;

		# Jpeg.
		if ($suffix eq 'jpg') {
			$suffix = 'jpeg';
		}

		# Check type.
		$self->_check_type($suffix);
	} else {
		$suffix = $self->{'type'};
	}

	# Fill.
	my $fill = Imager::Fill->new(
		'hatch' => 'check4x4',
		'fg' => $self->{'_flip_stay'} ? $self->{'fg'} : $self->{'bg'},
		'bg' => $self->{'_flip_stay'} ? $self->{'bg'} : $self->{'fg'},
	);
	$self->{'_flip_stay'} = $self->{'_flip_stay'} == 1 ? 0 : 1;

	# Add checkboard.
	$self->{'_imager'}->box('fill' => $fill);

	# Save file.
	my $ret = $self->{'_imager'}->write(
		'file' => $path,
		'type' => $suffix,
	);
	if (! $ret) {
		err "Cannot write file to '$path'.",
			'Error', $self->{'_imager'}->errstr;
	}
	
	return $suffix;
}

# Set/Get image type.
sub type {
	my ($self, $type) = @_;
	if ($type) {
		$self->_check_type($type);
		$self->{'type'} = $type;
	}
	return $self->{'type'};
}

# Check supported image type.
sub _check_type {
	my ($self, $type) = @_;

	# Check type.
	if (none { $type eq $_ } ('bmp', 'gif', 'jpeg', 'png',
		'pnm', 'raw', 'sgi', 'tga', 'tiff')) {

		err "Suffix '$type' doesn't supported.";
	}

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Image::Checkerboard - Image generator for checkboards.

=head1 SYNOPSIS

 use Image::Checkerboard;
 my $image = Image::Checkerboard->new(%parameters);
 my $suffix = $image->create($path);
 my $type = $image->type($type);

=head1 METHODS

=over 8

=item C<new(%parameters)>

 Constructor

=over 8

=item * C<bg>

 Background color.
 Default value is 'black'.

=item * C<flip>

 Flip flag. Means that each next video has reversed foreground and background.
 Default value is 1.

=item * C<fg>

 Foreground color.
 Default value is 'white'.

=item * C<height>

 Image height.
 Default value is 1080.

=item * C<type>

 Image type.
 Default value is 'bmp'.

=item * C<width>

 Image width.
 Default value is 1920.

=back

=item C<create($path)>

 Create image.
 Returns scalar value of supported file type.

=item C<type([$type])>

 Set/Get image type.
 Returns actual type of image.

=back

=head1 ERRORS

 new():
         From Class::Utils::set_params():
                 Unknown parameter '%s'.
 create():
         Cannot write file to '$path'.",
	         Error, %s
         Suffix '%s' doesn't supported.

 type():
         Suffix '%s' doesn't supported.


=head1 EXAMPLE

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use File::Temp qw(tempfile);
 use Image::Checkerboard;

 # Temporary file.
 my (undef, $temp) = tempfile();

 # Object.
 my $obj = Image::Checkerboard->new;

 # Create image.
 my $type = $obj->create($temp);

 # Print out type.
 print $type."\n";

 # Unlink file.
 unlink $temp;

 # Output:
 # bmp

=head1 DEPENDENCIES

L<Class::Utils>,
L<Error::Pure>,
L<Imager>,
L<Imager::Fill>.

=head1 SEE ALSO

L<Image::Random>,
L<Image::Select>.

=head1 REPOSITORY

L<https://github.com/tupinek/Image-Checkerboard>.

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

BSD 2-Clause License

=head1 VERSION

0.01

=cut
