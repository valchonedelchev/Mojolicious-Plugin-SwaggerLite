use Mojo::Base -strict;

use Test::More;
use Mojolicious::Lite;
use Test::Mojo;

plugin 'SwaggerLite';

get '/ok' => sub { shift->render( json => app->swagger_lite ) };
post '/ok';
put '/ok';
del '/ok';

my $t = Test::Mojo->new;

my $json = $t->get_ok('/ok')->status_is(200)->tx->res->json;
$t->json_is( '/swagger', '2.0' )->json_has('/paths');
is( $json->{paths}->{'/ok'}->{$_}->{operationId},
    'ok', "Got ok operationId for $_" )
    foreach qw(get put post delete);

done_testing();
