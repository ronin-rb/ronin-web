# ronin-web-server 1 "2022-01-01" Ronin Web "User Manuals"

## SYNOPSIS

`ronin-web-server` [*options*]

## DESCRIPTION

Starts a web server.

## OPTIONS

`-H`, `--host` *HOST*
  Host name or IP to bind to. Defaults to `localhost`.

`-p`, `--port` *PORT*
  Port number to listen on. Defaults to `8000`.

`-A`, `--basic-auth` *USER*:*PASSWORD*
  Sets up Basic-Authentication with the given *USER* and *PASSWORD*.

`-d`, `--dir` /*PATH*:*DIR*
  Mounts a directory to the given *PATH*.

`-f`, `--file` /*PATH*:*FILE*
  Mounts a file to the given *PATH*.

`-r`, `--root` *DIR*
  Root directory to serve.

`-R`, `--redirect` /*PATH*:*URL*
  Registers a `302 Found` redirect at the given *PATH*

`-h`, `--help`
  Print help information

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-web-proxy(1)
