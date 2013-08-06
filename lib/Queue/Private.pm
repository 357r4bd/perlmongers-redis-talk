package Queue::Private;

use strict;
use warnings;
use Digest::SHA qw/sha512_hex/;

use parent q{Queue}; 

sub new {
    my $pkg    = shift;
    my $params = shift;

    my $self = {};
    bless $self, $pkg;

    $self->_connect;

    # generate globally unique queue name 
    $self->{name} = sha512_hex($pkg, rand, $self->{redis}->incr($pkg));

    return $self;
}

1;
