# ronin-web-spider 1 "2022-01-01" Ronin Web "User Manuals"

## NAME

ronin-web-spider - Spiders a website

## SYNOPSIS

`ronin-web spider` [*options*] {`--host` *HOST* \| `--domain` *DOMAIN* \| `--site` *URL*}

## DESCRIPTION

Spiders a website.

## OPTIONS

`--host` *HOST*
: Spiders the specific *HOST*.

`--domain` *DOMAIN*
: Spiders the whole *DOMAIN*.

`--site` *URL*
: Spiders the website, starting at the *URL*.

`--open-timeout` *SECS*
: Sets the connection open timeout.

`--read-timeout` *SECS*
: Sets the read timeout.

`--ssl-timeout` *SECS*
: Sets the SSL connection timeout.

`--continue-timeout` *SECS*
: Sets the continue timeout.

`--keep-alive-timeout` *SECS*
: Sets the connection keep alive timeout.

`-P`, `--proxy` *PROXY*
: Sets the proxy to use.

`-H`, `--header` "*NAME*: *VALUE*"
: Sets a default header.

`--host-header` *NAME*=*VALUE*
: Sets a default header.

`-u`, `--user-agent` chrome-linux|chrome-macos|chrome-windows|chrome-iphone|chrome-ipad|chrome-android|firefox-linux|firefox-macos|firefox-windows|firefox-iphone|firefox-ipad|firefox-android|safari-macos|safari-iphone|safari-ipad|edge
: The `User-Agent` to use.

`-U`, `--user-agent-string` *STRING*
: The raw `User-Agent` string to use.

`-R`, `--referer` *URL*
: Sets the `Referer` URL.

`--delay` *SECS*
: Sets the delay in seconds between each request.

`-l`, `--limit` *COUNT*
: Only spiders up to *COUNT* pages.

`-d`, `--max-depth` *DEPTH*
: Only spiders up to max depth.

`--enqueue` *URL*
: Adds the URL to the queue.

`--visited` *URL*
: Marks the URL as previously visited.

`--strip-fragments`
: Enables/disables stripping the fragment component of every URL.

`--strip-query`
: Enables/disables stripping the query component of every URL.

`--visit-scheme` *SCHEME*
: Visit URLs with the URI scheme.

`--visit-schemes-like` `/`*REGEX*`/`
: Visit URLs with URI schemes that match the *REGEX*.

`--ignore-scheme` *SCHEME*
: Ignore URLs with the URI scheme.

`--ignore-schemes-like` `/`*REGEX*`/`
: Ignore URLs with URI schemes matching the *REGEX*.

`--visit-host` *HOST*
: Visit URLs with the matching host name.

`--visit-hosts-like` `/`*REGEX*`/`
: Visit URLs with hostnames that match the *REGEX*.

`--ignore-host` *HOST*
: Ignore the host name.

`--ignore-hosts-like` `/`*REGEX*`/`
: Ignore the host names matching the *REGEX*.

`--visit-port` *PORT*
: Visit URLs with the matching port number.

`--visit-ports-like` `/`*REGEX*`/`
: Visit URLs with port numbers that match the *REGEX*.

`--ignore-port` *PORT*
: Ignore the port number.

`--ignore-ports-like` `/`*REGEX*`/`
: Ignore the port numbers matching the *REGEXP*.

`--visit-link` *URL*
: Visit the *URL*.

`--visit-links-like` `/`*REGEX*`/`
: Visit URLs that match the *REGEX*.

`--ignore-link` *URL*
: Ignore the *URL*.

`--ignore-links-like` `/`*REGEX*`/`
: Ignore URLs matching the *REGEX*.

`--visit-ext` *FILE_EXT*
: Visit URLs with the matching file ext.

`--visit-exts-like` `/`*REGEX*`/`
: Visit URLs with file exts that match the *REGEX*.

`--ignore-ext` *FILE_EXT*
: Ignore the URLs with the file ext.

`--ignore-exts-like` `/`*REGEX*`/`
: Ignore URLs with file exts matching the REGEX.

`-r`, `--robots`
: Specifies whether to honor `robots.txt`.

`--print-status`
: Print the status codes for each URL.

`--print-headers`
: Print response headers for each URL.

`--print-header` *NAME*
: Prints a specific header.

`--history` *FILE*
: Sets the history file to write every visited URL to.

`--archive` *DIR*
: Archive every visited page to the *DIR*.

`--git-archive` *DIR*
: Archive every visited page to the git repository.

`-X`, `--xpath` *XPATH*
: Evaluates the XPath on each HTML page.

`-C`, `--css-path` *XPATH*
: Evaluates the CSS-path on each HTML page.

`--print-hosts`
: Print all discovered hostnames.

`--print-certs`
: Print all encountered SSL/TLS certificates.

`--save-certs`
: Saves all encountered SSL/TLS certificates.

`--print-js-strings`
: Print all JavaScript strings.

`--print-js-url-strings`
: Print URL strings found in JavaScript.

`--print-js-path-strings`
: Print path strings found in JavaScript.

`--print-js-relative-path-strings`
: Only print relative path strings found in JavaScript.

`--print-html-comments`
: Print HTML comments.

`--print-js-comments`
: Print JavaScript comments.

`--print-comments`
: Print all HTML and JavaScript comments.

`-v`, `--verbose`
: Enables verbose output.

`-h`, `--help`
: Print help information.

## ENVIRONMENT

*HTTP_PROXY*
: Sets the global HTTP proxy.

*RONIN_HTTP_PROXY*
: Sets the HTTP proxy for Ronin.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-web-server](ronin-web-server.1.md) [ronin-web-proxy](ronin-web-proxy.1.md) [ronin-web-diff](ronin-web-diff.1.md) [ronin-web-new-spider](ronin-web-new-spider.1.md)
