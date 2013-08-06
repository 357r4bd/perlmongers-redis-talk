package Queue::JSON;

use strict;
use warnings;

use parent q{Queue};
use JSON::XS ();

use Exception::Class ( 
  'X::InvalidPayload' => { isa => 'X::Fatal' }, 
  'X::InvalidJSON' => { isa => 'X::Fatal' }, 
);

sub _encode {
  my $self = shift;
  my $payload = shift;
  if (ref $payload ne q{HASH} and ref $payload ne q{ARRAY}) {
    throw X::InvalidPayload("Payload must be a hash ref or array ref"); 
  }
  return JSON::XS::encode_json($payload);
}

sub _decode {
  my $self = shift;
  my $payload = shift;
  local $@;
  return eval { JSON::XS::decode_json($payload) } or throw X::InvalidJSON($@) ;
}

1;
