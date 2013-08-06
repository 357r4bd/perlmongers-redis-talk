package Queue;

use strict;
use warnings;
use Data::Dumper ();

use parent q{Redis};
use Exception::Class ( 'X::Fatal', 'X::CantConnect' => { isa => 'X::Fatal' }, );

sub new {
    my $pkg    = shift;
    my $params = shift;

    my $self = { name => $params->{name} || q{myqueue}, };

    bless $self, $pkg;

    my $ok = eval {
        $self->{redis} = Redis->new( server => q{192.168.3.2:6379} )
    } or throw X::CantConnect;

    return $self;
}

# serialization hook
sub _encode {
  my $self = shift;
  my $payload = shift;
  return $payload;
}

# deserialization hook
sub _decode {
  my $self = shift;
  my $payload = shift;
  return $payload;
}

sub submit_task {
    my $self    = shift;
    my $payload = shift;
    return $self->{redis}->rpush( $self->{name}, $self->_encode($payload) );
}

sub bget_task {
    my $self = shift;
    my $timeout = shift // 1;
    my ( $list, $payload ) = $self->{redis}->blpop( $self->{name}, $timeout );
    return $self->_decode( $payload );
}

sub get_task {
    my $self = shift;
    my ( $list, $payload ) = $self->{redis}->lpop( $self->{name} );
    return $self->_decode( $payload );
}

1;
