# ronin-web-new-spider 1 "May 2022" Ronin "User Manuals"

## SYNOPSIS

`ronin-web new spider` [*options*] {`--host`[`=`*HOST*] \| `--domain`[`=`*DOMAIN*] \| `--site`[`=`*URL*]} [*FILE*]

## DESCRIPTION

Generates a new spider Ruby script.

## ARGUMENTS

*FILE*
  The file to create.

## OPTIONS

`--host`[`=`*HOST*]
  Spiders a host.

`--domain`[`=`*DOMAIN*]
  Spiders a domain.

`--site`[`=`*URL*]
  Spiders a site.

`--every-link`
  Adds a callback for every link.

`--every-url`
  Adds a callback for every URL.

`--every-failed-url`
  Adds a callback for every failed URL.

`--every-url-like` `/`*REGEXP*`/`
  Adds a callback for every URL that matches the regexp.

`--all-headers`
  Adds a callback for all HTTP Headers.

`--every-page`
  Adds a callback for every page.

`--every-ok-page`
  Adds a callback for every HTTP 200 page.

`--every-redirect-page`
  Adds a callback for every redirect page.

`--every-timedout-page`
  Adds a callback for every timedout page.

`--every-bad-request-page`
  Adds a callback for every bad request page.

`--every-unauthorized-page`
  Adds a callback for every unauthorized page.

`--every-forbidden-page`
  Adds a callback for every forbidden page.

`--every-missing-page`
  Adds a callback for every missing page.

`--every-internal-server-error-page`
  Adds a callback for every internal server error page.

`--every-txt-page`
  Adds a callback for every TXT page.

`--every-html-page`
  Adds a callback for every HTML page.

`--every-xml-page`
  Adds a callback for every XML page.

`--every-xsl-page`
  Adds a callback for every XSL page.

`--every-javascript-page`
  Adds a callback for every JavaScript page.

`--every-css-page`
  Adds a callback for every CSS page.

`--every-rss-page`
  Adds a callback for every RSS page.

`--every-atom-page`
  Adds a callback for every Atom page.

`--every-ms-word-page`
  Adds a callback for every MS Wod page.

`--every-pdf-page`
  Adds a callback for every PDF page.

`--every-zip-page`
  Adds a callback for every ZIP page.

`--every-doc`
  Adds a callback for every HTML/XML document.

`--every-html-doc`
  Adds a callback for every HTML document.

`--every-xml-doc`
  Adds a callback for every XML document.

`--every-xsl-doc`
  Adds a callback for every XSL document.

`--every-rss-doc`
  Adds a callback for every RSS document.

`--every-atom-doc`
  Adds a callback for every Atom document.

`-h`, `--help`
  Print help information

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-web-new-nokogiri(1) ronin-web-new-server(1) ronin-web-new-app(1)
