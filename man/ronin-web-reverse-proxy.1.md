# ronin-web-reverse-proxy 1 "2022-01-01" Ronin "User Manuals"

## NAME

ronin-web-reverse-proxy - Starts a HTTP proxy server

## SYNOPSIS

`ronin-web reverse-proxy` [*options*] [`--host` *HOST*] [`--port` *PORT*]

## DESCRIPTION

Starts a HTTP reverse proxy server.

## OPTIONS

`-H`, `--host` *HOST*
: The host that the proxy server will listen on. Defaults to `localhost`.

`-p`, `--port` *PORT*
: The port that the proxy server will listen on. Default to `8080`.

`-b`, `--show-body`
: Controls whether to display the request/response bodies or not.

`--rewrite-requests` {*STRING*:*REPLACE*|/*REGEXP*/:*REPLACE*}
: Rewrites all request bodies by replacing the *STRING* or *REGEXP* with the
  given *REPLACE* string.

`--rewrite-responses` {*STRING*:*REPLACE*|/*REGEXP*/:*REPLACE*}
: Rewrites all response bodies by replacing the *STRING* or *REGEXP* with the
  given *REPLACE* string.

`-h`, `--help`
: prints help information.

## EXAMPLES

Listen on the external interface on port 80:

    $ sudo ronin-web reverse-proxy --host 0.0.0.0 --port 80

Replace every occurrence of `https` with `http` in the response bodies:

    $ ronin-web reverse-proxy --rewrite-responses https:http

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-web-server](ronin-web-server.1.md)
