package Mojolicious::Plugin::Libravatar;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '1.00';

use Libravatar::URL;
use Mojo::Cache;

sub register {
    my ( $self, $app, $conf ) = @_;

    $conf           //= {};
    $conf->{size}   //= 80;
    $conf->{rating} //= 'PG';
    my $mojo_cache = $conf->{mojo_cache};
    delete $conf->{mojo_cache} if defined $mojo_cache;
    my $cache;
    $cache = Mojo::Cache->new if $mojo_cache;

    $app->helper(
        libravatar_url => sub {
            my ( $c, $email, %options ) = @_;
            return libravatar_url( email => $email, %{$conf}, %options )
              if not defined $cache;

            my $url = $cache->get($email);
            if ( not $url ) {
                $url = libravatar_url( email => $email, %{$conf}, %options );
                $cache->set( $email => $url );
            }
            return $url;
        }
    );
}


"Donuts. Is there anything they can't do?"

__END__

=head1 NAME

Mojolicious::Plugin::Libravatar - Access the Libravatar API in Mojolicious.

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin(
        'Libravatar',
        {
            size       => 30,
            https      => 1,
            mojo_cache => 1, # optional to enable cacheing
        }
        );

  # Mojolicious::Lite
  plugin 'Libravatar';

  % my $url = libravatar_url 'user@info.com', size => 80;

=head1 DESCRIPTION

L<Mojolicious::Plugin::Libravatar> provides access to the open source
Libravatar API L<http://www.libravatar.org>. It utilizes the L<Libravatar::URL>
library internally and configuration and options to the helper method
L<libravatar_url|Mojolicious::Plugin::Libravatar/libravatar_url> are passed
to it directly.

=head1 METHODS

L<Mojolicious::Plugin::Libravatar> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 C<register>

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 CONFIG

L<Mojolicious::Plugin::Libravatar> accepts the same options as
L<Libravatar::URL>, including C<size>, C<https>, C<base>, and C<short_keys>.
However, one additional parameter has been added:

=head2 mojo_cache

This is a boolean parameter (0|1) which, when I<true>, tells the plugin to
store urls in a cache. For now, this is done with L<Mojo::Cache>.

=head1 HELPERS

=head2 libravatar_url

Given an email, returns a url for the corresponding avatar. Options
 override configuration.

    # In code
    my $url = $app->libravatar('email',%options);

    # Template
    % my $url = libravatar_url 'user@info.com', size => 80,...;


=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>,
L<Libravatar::URL>, L<http://www.libravatar.org>.

=head1 SOURCE

L<git://github.com/heytrav/mpl.git>


=cut
