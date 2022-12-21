# ronin-web-new-webapp 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin-web new webapp` [*options*] [*DIR*]

## DESCRIPTION

Generates a new `ronin-web-server` based webapp.

## ARGUMENTS

*DIR*
  The project directory to create.

## OPTIONS

`--port` *PORT*
  The port the webpp will listen on by default. Defaults to `3000`.

`--ruby-version` *VERSION*
  The desired ruby version for the project Defaults to the current ruby version.

`--git`
  Initializes a git repo.

`-D`, `--dockerfile`
  Adds a `Dockerfile` and a `docker-compose.yml` file to the new project.

`-h`, `--help`
  Print help information

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-web-new-nokogiri(1) ronin-web-new-server(1) ronin-web-new-spider(1)
