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
        return $app;
    },
);

test  http_request => { desc => "Request an avatar without https" } => sub {
    my $self = shift;
    my $url = $self->tests;
    is( $url->scheme, 'http', 'Request made over SSL' );
};

test  https_request => { desc => "Request an avatar without https" } => sub {
    my $self = shift;
    my $url = $self->tests( https => 1 );
    is( $url->scheme, 'https', 'Request made over SSL' );

};

sub tests {
    my ( $self, %options ) = @_;
    my $app = $self->mojo_app;
    lives_ok {
        $app->plugin(
            Libravatar => {
                size    => 50,
                default => '~/nobody.jpg',
                %options,
            }
        );
    }
    'Registered plugin.';
    my $url_string;
    lives_ok {
        $url_string = $app->libravatar_url('user@info.com');
        ### url string : $url_string
    }
    'Fetched URL for email';

    my $url = Mojo::URL->new($url_string);
    return $url;
}


run_me;

done_testing;

