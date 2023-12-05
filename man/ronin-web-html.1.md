# ronin-web-html 1 "2022-01-01" Ronin "User Manuals"

## NAME

ronin-web-html - Performs XPath/CSS-path queries on a URL or HTML file

## SYNOPSIS

`ronin-web html` [*options*] {*URL* \| *FILE*} [*XPATH* \| *CSS-path*]

## DESCRIPTION

Performs XPath/CSS-path queries on a URL or HTML file.

## ARGUMENTS

*URL*
: The `http://` or `https://` URL to fetch and parse.

*FILE*
: The local HTML file to parse.

*XPATH*
: The XPath query expression.

*CSS-path*
: The CSS-path query expression.

## OPTIONS

`-X`, `--xpath` *XPATH*
: The XPath query to perform.

`-C`, `--css-path` *CSS-path*
: The CSS-path query to perform.

`-M`, `--meta-tags`
: Searches for all `<meta ...>` tags.

`-l`, `--links`
: Searches for all `<a href="...">` URLs.

`-S`, `--style`
: Dumps all `<style>` tags.

`-s`, `--stylesheet-urls`
: Searches for all `<link type="text/css" href="..."/>` URLs.

`-J`, `--javascript`
: Dumps all javascript source code.

`-j`, `--javascript-urls`
: Searches for all `<script src="...">` URLs.

`-f`, `--form-urls`
: Searches for all `<form action="...">` URLS.

`-u`, `--urls`
: Dumps all URLs in the page.

`-F`, `--first`
: Only print the first match.

`-h`, `--help`
: Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

