# ronin-web-screenshot 1 "2023-05-01" Ronin Web "User Manuals"

## SYNOPSIS

`ronin-web-screenshot` [*options*] {*URL* [...] | `--file` *FILE*}

## DESCRIPTION

Screenshots one or more URLs.

## ARGUMENTS

*URL*
  A `https://` or `http://` URL of the web page to diff.

## OPTIONS

`-B`, `--browser` *NAME*\|*PATH*
  The browser name or path to execute.

`-W`, `--width` *WIDTH*
  Sets the width of the browser viewport. Defaults to `1024` if not given.
  .
`-H`, `--height` *HEIGHT*
  Sets the height of the browser viewport. Defaults to `768` if not given.

`-f`, `--file` *FILE*
  Input file to read URLs from.

`-F`, `--format` `png`\|`jpg`
  Screenshot image file format to use. Defaults to `png` if not given.

`-d`, `--directory` *DIR*
  Directory to save images to. Defaults to the current working directory if not
  given.

`-f`, `--full`
  Screenshots the full page.

`-C`, `--css-path` *CSSPath*
  The CSSpath selector to screenshot.

`-h`, `--help`
  Print help information

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-web-browser(1)
