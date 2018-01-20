use 5.006;
use strict;
use warnings;

package Test::cXML;
use base 'Exporter';

use Clone qw(clone);

our @EXPORT_OK = qw(comparable);

# Resets/removes dynamic things from cXML documents hashes (or nodes, which
# are converted to hashes), transmission objects, etc.
sub comparable {
	my ($hash) = @_;
	$hash = $hash->toHash if ref($hash) =~ /^XML::LibXML::/;
	if (ref($hash) eq 'Business::cXML::Transmission') {
		# CAUTION: This XML reset makes the object UNUSABLE for further processing!
		$hash->{xml_doc}     = undef;
		$hash->{xml_root}    = undef;
		$hash->{xml_payload} = undef;
		$hash->{timestamp}   = 'timestamp';
		$hash->{epoch}       = 'epoch';
		$hash->{hostname}    = 'hostname';
		$hash->{randint}     = 'randint';
		$hash->{pid}         = 'pid';
		$hash->{id}          = 'id';
	} elsif (ref($hash) eq 'HASH') {
		delete $hash->{__attributes}{timestamp} if exists $hash->{__attributes}{timestamp};
		delete $hash->{__attributes}{payloadID} if exists $hash->{__attributes}{payloadID};
		delete $hash->{Request}->[0]->{__attributes}{deploymentMode}
			if exists $hash->{Request}
			&& exists $hash->{Request}->[0]->{__attributes}{deploymentMode}
		;
		delete $hash->{Header}->[0]->{Sender}->[0]->{UserAgent}
			if exists $hash->{Header}
			&& exists $hash->{Header}->[0]->{Sender}
			&& exists $hash->{Header}->[0]->{Sender}->[0]->{UserAgent}
		;
	};
	return $hash;
}

1;
