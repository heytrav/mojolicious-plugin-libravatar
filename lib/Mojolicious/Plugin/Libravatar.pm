package Mojolicious::Plugin::Libravatar;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.02';

use Libravatar::URL;
use Mojo::Cache;

sub register {
    my ( $self, $app, $conf ) = @_;

    $conf               //= {};
    $conf->{size}       //= 80;
    $conf->{rating}     //= 'PG';
    $conf->{mojo_cache} //= 0;
    my $mojo_cache = $conf->{mojo_cache} // 0;
    my $cache;
    $cache = Mojo::Cache->new if $mojo_cache;

    $app->helper(
        libravatar_url => sub {
            my ( $c, $email, %options ) = @_;
            return libravatar_url( email =>$email, %options ) if not defined $cache;

            my $url = $cache->get($email);
            if ( not $url ) {
                $url = libravatar_url(email => $email, %options );
                $cache->set( $email => $url );
            }
            return $url;
        }
    );
}

"All work and no beer make Homer something something.";
__END__

=head1 NAME

Mojolicious::Plugin::Libravatar - Return a 

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('Libravatar');

  # Mojolicious::Lite
  plugin 'Libravatar';

=head1 DESCRIPTION

L<Mojolicious::Plugin::Libravatar> is a L<Mojolicious> plugin.

=head1 METHODS

L<Mojolicious::Plugin::Libravatar> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 C<register>

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut
