package Queue;

use strict;
use warnings;
use Digest::SHA qw/sha512_hex/;

use parent q{Redis};
use Exception::Class (
    'X::Fatal',
    'X::CantConnect'      => { isa => 'X::Fatal' },
    'X::QueueNameMissing' => { isa => 'X::Fatal' },
);

X::Fatal->Trace(1);

sub new {
    my $pkg    = shift;
    my $params = shift;

    my $self =
      {      name => $params->{name}
          || throw X::QueueNameMissing(q{'name' parameter required}), };

    bless $self, $pkg;

    $self->_connect;

    return $self;
}

sub _connect {
    my $self = shift;
    my $ok =
      eval { $self->{redis} = Redis->new( server => q{192.168.3.2:6379} ) }
      or throw X::CantConnect;

      # register GUID for this client using Redis' atomic incr
      my $pkg = ref $self;
      $self->{id} = sha512_hex($pkg, rand, $self->{redis}->incr($pkg));

    return;
}

# serialization hook
sub _encode {
    my $self    = shift;
    my $payload = shift;
    return $payload;
}

# deserialization hook
sub _decode {
    my $self    = shift;
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
    return $self->_decode($payload);
}

sub get_task {
    my $self = shift;
    my ( $list, $payload ) = $self->{redis}->lpop( $self->{name} );
    return $self->_decode($payload);
}

sub delete_queue {
    my $self = shift;
    return $self->{redis}->del($self->{name});
}

1;
