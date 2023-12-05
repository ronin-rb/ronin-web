# ronin-web-diff 1 "2022-01-01" Ronin Web "User Manuals"

## NAME

ronin-web-diff - Diffs two web pages

## SYNOPSIS

`ronin-web diff` [*options*] {*URL* \| *FILE*} {*URL* \| *FILE*}

## DESCRIPTION

Diffs two separate HTML or XML pages and prints the HTML/XML nodes which were changed.

## ARGUMENTS

*URL*
: A `https://` or `http://` URL of the web page to diff.

*FILE*
: A path to the local HTML or XML file to diff.

## OPTIONS

`-h`, `--help`
: Print help information

`-f`, `--format` `html`|`xml`
: Pass the format of the URL or files. Supported formats are `html` and `xml`. (Default: `html`)

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-web-html](ronin-web-html.1.md)
