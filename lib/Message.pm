package Message;

use strict;
use warnings;

use parent q{Task};
use Digest::SHA qw/sha512_hex/;

use Exception::Class ( 'X::MissingHeader' => { isa => 'X::Fatal' }, );

sub new {
    my $pkg     = shift;
    my $payload = shift;
    my $headers = shift;

    # only basic validation
    throw X::MissingPayload if not $payload or ref $payload ne q{HASH};

    # initialize fields
    my $self = {
        id => sha512_hex( $pkg, rand, rand, rand ),
        type    => $pkg,
        payload => $payload,
        # header info can be set if defined as second hash ref with 'to', 'from', & optional 'replyto' field
        to      => $headers->{to}      // undef,
        from    => $headers->{from}    // undef,
    };
    bless $self, $pkg;
    return $self;
}

sub _encode_message {
    my $self = shift;

    # use important hash keys
    return JSON::XS::encode_json(
        {
            id      => $self->{id},
            type    => $self->{type},
            payload => $self->{payload},
            # build headers, throw fatal exception if 'to' or 'from' is missing
            to => $self->{to} //  throw X::MissingHeader(q{'to' field not set}),
            from => $self->{from} // throw X::MissingHeader(q{'from' field not set}),
        }
    );
}

sub _decode_message {
  my $self = shift;
  return $self->_decode_task(@_);
}

1;
