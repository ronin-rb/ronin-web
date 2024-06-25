# ronin-web-xml 1 "2022-01-01" Ronin "User Manuals"

## NAME

ronin-web-xml - Performs XPath queries on a URL or XML file

## SYNOPSIS

`ronin-web xml` [*options*] {*URL* \| *FILE*} [*XPATH*]

## DESCRIPTION

Performs XPath queries on a URL or XML file.

## ARGUMENTS

*URL*
: The `http://` or `https://` URL to fetch and parse.

*FILE*
: The local XML file to parse.

*XPATH*
: The XPath query expression.

## OPTIONS

`-X`, `--xpath` *XPATH*
: The XPath query to perform.

`-F`, `--first`
: Only print the first match.

`-t`, `--text`
: Prints the inner-text of the matching elements.

`-h`, `--help`
: Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-web-html](ronin-web-html.1.md)
