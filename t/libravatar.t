package Libravatar::Tester;

use Test::Routine;
use Test::Routine::Util;
use Test::Mojo;
use Mojo::URL;
use Mojolicious::Lite;
use Test::More;
use Test::Exception;

#use Smart::Comments;

has mojo_app => (
    is      => 'ro',
    isa     => 'Mojolicious::Lite',
    clearer => 'reset_app',
    default => sub {
        my $test_mojo = Test::Mojo->new();
        my $app       = $test_mojo->app;
        $app->mode('development');
        $app->plugin(
            Libravatar => {
                size    => 50,
                default => '~/nobody.jpg',
            }
        );
        return $app;
    },
);

has cached_mojo_app => (
    is      => 'ro',
    isa     => 'Mojolicious::Lite',
    default => sub {
        my $test_mojo = Test::Mojo->new();
        my $app       = $test_mojo->app;
        $app->mode('development');
        $app->plugin(
            Libravatar => {
                size       => 50,
                default    => '~/nobody.jpg',
                mojo_cache => 1,
            }
        );
        return $app;
    },
);

test http_request => { desc => "Request an avatar without https" } => sub {
    my $self = shift;
    my $app  = $self->mojo_app;
    my $url  = $self->tests($app);
    is( $url->scheme, 'http', 'Request made over SSL' );
};

test https_request => { desc => "Request an avatar without https" } => sub {
    my $self = shift;
    my $app  = $self->mojo_app;
    my $url  = $self->tests( $app, https => 1 );
    is( $url->scheme, 'https', 'Request made over SSL' );

};

test cached_request => { desc => "Make a cached request" } => sub {
    my $self = shift;
    my $app  = $self->cached_mojo_app;
    my $url  = $self->tests( $app, https => 1 );
    is( $url->scheme, 'https', 'Request made over SSL' );
};

test cached_request2 => { desc => "Make second cached request" } => sub {
    my $self = shift;
    my $app  = $self->cached_mojo_app;
    my $url  = $self->tests( $app, https => 1 );
    is( $url->scheme, 'https', 'Request made over SSL' );
};

sub tests {
    my ( $self, $app, %options ) = @_;
    my $url_string;
    lives_ok {
        $url_string = $app->libravatar_url( 'user@info.com', %options );
        ### url string : $url_string
    }
    'Fetched URL for email';

    my $url = Mojo::URL->new($url_string);
    return $url;
}

run_me;

done_testing;

