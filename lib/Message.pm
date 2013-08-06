package Message;

use strict;
use warnings;
use JSON::XS ();
use Digest::SHA qw/sha512_hex/;

use Exception::Class (
    'X::Fatal',
    'X::InvalidPayload' => { isa => 'X::Fatal' },
    'X::InvalidJSON'    => { isa => 'X::Fatal' },
    'X::InvalidField'   => { isa => 'X::Fatal' },
);

sub new {
    my $pkg     = shift;
    my $payload = shift;
    my $headers = shift;
    if (    ref $payload ne q{SCALAR}
        and ref $payload ne q{HASH}
        and ref $payload ne q{ARRAY} )
    {
        throw X::InvalidPayload(
            "Payload must be a scalar, hash ref, array ref");
    }
    my $self = {
        id => sha512_hex( $pkg, rand, rand, rand ),
        to   => $headers->{to}   // throw X::InvalidHeader('to not defined'),
        from => $headers->{from} // throw X::InvalidHeader('from not defined'),
        replyto => $headers->{replyto} // $headers->{from},
        type    => $pkg,
        payload => $payload            // undef,
    };
    bless $self, $pkg;
    return $self;
}

#
sub _encode_task {
    my $self = shift;

    # use important hash keys
    return JSON::XS::encode_json(
        {
            type    => $self->{type},
            payload => $self->{payload},
            id      => $self->{id},
            to      => $self->{to},
            from    => $self->{from},
            replyto => $self->{replytl},
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
