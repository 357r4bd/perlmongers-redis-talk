package Task;

use strict;
use warnings;
use JSON::XS ();

use Exception::Class (
    'X::Fatal',
    'X::InvalidPayload' => { isa => 'X::Fatal' },
    'X::InvalidJSON'    => { isa => 'X::Fatal' },
);

sub new {
    my $pkg     = shift;
    my $payload = shift;
    if (    ref $payload ne q{SCALAR}
        and ref $payload ne q{HASH}
        and ref $payload ne q{ARRAY} )
    {
        throw X::InvalidPayload(
            "Payload must be a scalar, hash ref, array ref");
    }
    my $self = {
        type    => $pkg,
        payload => $payload || undef
    };
    bless $self, $pkg;
    return $self;
}

#
sub _encode_task {
    my $self = shift;
    # use important hash keys
    return JSON::XS::encode_json(
        { type => $self->{type}, payload => $self->{payload} } );
}

sub _decode_task {
    my $self = shift;
    my $json = shift;
    local $@;
    my $task_ref = eval { JSON::XS::decode_json( $json ) }
      or throw X::InvalidJSON($@);
    # create hash_ref, then bless it to embue properties of type $pkg
    bless $task_ref, $task_ref->{type};
    return $task_ref;
}

1;
