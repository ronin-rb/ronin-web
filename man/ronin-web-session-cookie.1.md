# ronin-web-session-cookie 1 "2023-03-01" Ronin "User Manuals"

## NAME

ronin-web-session-cookie - Parses and deserializes various session cookie formats

## SYNOPSIS

`ronin-web session-cookie` [*options*] {*URL* \| *STRING*}

## DESCRIPTION

Parses and deserializes various session cookie formats. Currently supports
Python Django (JSON and Pickle), JSON Web Token (JWT), and Ruby Rack session
cookies.

## ARGUMENTS

*URL*
: The `http://` or `https://` URL to request and extract the session cookie
  from.

*STRING*
: The session cookie string to parse.

## OPTIONS

`-F`, `--format` [`ruby` \| `json` \| `yaml`]
: The format to print the session cookie params. Defaults to `ruby` if not
  given.

`-v`, `--verbose`
: Enables verbose output.

`-h`, `--help`
: Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

