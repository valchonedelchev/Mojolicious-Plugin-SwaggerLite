package Mojolicious::Plugin::SwaggerLite;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.01';

my $output = {
    swagger => '2.0',
    info    => {
        version => '1.0',
        title   => 'API'
    },
    host     => 'localhost:3000',
    basePath => '/',
    schemes  => [ 'http', 'https' ],
    consumes => ["application/json"],
    produces => ["application/json"],
    paths    => {}
};

my $known_type = { id => 'integer' };

sub register {
    my ( $self, $app ) = @_;
    $app->helper(
        swagger_lite => sub {
            process_route($_) foreach @{ $app->routes->children };
            return $output;
        }
    );
}

sub process_route {
    my $route = shift;

    my $path = $route->pattern->unparsed ? $route->pattern->unparsed : '/';

    foreach my $via ( @{ $route->via } ) {
        my ( $endpoint, $data ) = (
            $path,
            {   parameters  => [],
                tags        => [],
                operationId => $route->name,
                summary     => '',
                description => '',
                responses   => { 200 => { description => "OK" }, },
            }
        );

        $endpoint =~ s/[\:\#\*]([^\/]*)/\{$1\}/g;
        $endpoint =~ s/\{\}//g;

        $data->{parameters} = extract_parameters($endpoint);

        $output->{paths}->{$endpoint}->{ lc($via) } = $data;
    }

    if ( $route->children ) {
        process_route($_) foreach @{ $route->children };
    }
}

sub extract_parameters {
    my $url = shift;

    my @params;
    while ( $url =~ m/\{(.*?)\}/g ) {
        my $name = $1;
        my $type
            = exists $known_type->{$name} ? $known_type->{$name} : 'string';
        push @params,
            {
            name     => $name,
            type     => $type,
            in       => 'path',
            required => 'true'
            };
    }

    return \@params;
}

sub route_default_struct {
    my $route = shift;

    return {
        parameters  => [],
        tags        => [],
        operationId => $route->name,
        summary     => '',
        description => '',
        responses   => { 200 => { description => "OK" }, },
    };
}

1;
__END__

=encoding utf8

=head1 NAME

Mojolicious::Plugin::SwaggerLite - Mojolicious Plugin

This plugin allows you to generate swagger JSON configuration on the fly
based on the routes of you lite_app.

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('SwaggerLite');
  $self->render( json => swagger_lite );

  # Mojolicious::Lite
  plugin 'SwaggerLite';
  $c->render( json => app->swagger_lite );


=head1 DESCRIPTION

L<Mojolicious::Plugin::SwaggerLite> is a L<Mojolicious> plugin.

=head1 METHODS

L<Mojolicious::Plugin::SwaggerLite> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 AUTHOR

Valcho Nedelchev <weby@cpan.org>

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicious.org>.

=cut
