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

	# Background.
	$self->{'bg'} = 'black';

	# Flip flag.
	$self->{'flip'} = 1;

	# Foreground.
	$self->{'fg'} = 'white';

	# Sizes.
	$self->{'width'} = 1920;
	$self->{'height'} = 1080;

	# Image type.
	$self->{'type'} = 'jpeg';

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
