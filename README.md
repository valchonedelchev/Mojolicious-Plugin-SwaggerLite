# Mojolicious-Plugin-SwaggerLite
Generates Swagger2 JSON on the fly based on the routes in the app, lite_app.

[![Build Status](https://travis-ci.org/valchonedelchev/Mojolicious-Plugin-SwaggerLite.svg?branch=master)](https://travis-ci.org/valchonedelchev/Mojolicious-Plugin-SwaggerLite)

### Usage example
- Install Mojolicious and Mojolicious-Plugin-SwaggerLite

```
cpanm git://github.com/valchonedelchev/Mojolicious-Plugin-SwaggerLite
mojo generate lite_app app
```

- Add the following to your `app`

```
# under the lite app
plugin 'SwaggerLite';

# url to git into the Swagger2 UI
get '/doc' => sub {
  shift->render( json => app->swagger_lite );
};
```

- Install `Swagger UI`

```
bower install swagger-ui
ls public/lib/swagger-ui/dist/index.html
mprbo app
```

- Point your browser to [http://localhost:3000/lib/swagger-ui/dist/index.html?url=/](http://localhost:3000/lib/swagger-ui/dist/index.html?url=/)


# Author
Valcho Nedelchev <weby@cpan.org>

😎

