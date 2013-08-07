package Task;

use strict;
use warnings;
use JSON::XS ();
use Digest::SHA qw/sha512_hex/;

use Exception::Class (
    'X::Fatal',
    'X::InvalidJSON'    => { isa => 'X::Fatal' },
    'X::MissingPayload' => { isa => 'X::Fatal' },
);

sub new {
    my $pkg     = shift;
    my $payload = shift;

    # only basic validation
    throw X::MissingPayload if not $payload or ref $payload ne q{HASH};

    # initialize fields
    my $self = {
        id => sha512_hex( $pkg, rand, rand, rand ),
        type    => $pkg,
        payload => $payload, 
    };

    bless $self, $pkg;
    return $self;
}

sub _encode_task {
    my $self = shift;

    # use important hash keys
    return JSON::XS::encode_json(
        {
            id      => $self->{id},
            type    => $self->{type},
            payload => $self->{payload}
        }
    );
}

sub _decode_task {
    my $self = shift;
    my $json = shift;
    local $@;
    my $task_ref = eval { JSON::XS::decode_json($json) }
      or throw X::InvalidJSON($@);

    # create hash_ref, then bless it to embue properties of type $pkg
    bless $task_ref, $task_ref->{type};
    return $task_ref;
}

1;
