# ronin-web-spider 1 "2022-01-01" Ronin Web "User Manuals"

## NAME

ronin-web-wordlist - Builds a wordlist by spidering a website

## SYNOPSIS

`ronin-web wordlist` [*options*] {`--host` *HOST* \| `--domain` *DOMAIN* \| `--site` *URL*}

## DESCRIPTION

Builds a wordlist by spidering a website.

## OPTIONS

`-o`, `--output` *PATH*
: The wordlist file to write to.

`-X`, `--content-xpath` *XPATH*
: The XPath expression for where the content exists in each HTML page.

`-C`, `--content-css-path` *CSS-path*
: The CSS-path expression for where the content exists in each HTML page.

`--meta-tags`
: Parses `keywords` and `description` `<meta>` tags while spidering HTML pages.
  This is enabled by default.

`--no-meta-tags`
: Ignore `<meta>` tags while spidering HTML pages.

`--comments`
: Parses HTML comments while spidering HTML pages.
  This is enabled by default.

`--no-comments`
: Ignores HTML comments while spidering HTML pages.

`--alt-tags`
: Parses `alt=` attribute tags on `<img>`, `<area>`, and `<input>`.

`--no-alt-tags`
: Ignore `alt=` attribute tags while spidering HTML pages.

`--paths`
: Parses the directory names from all spidered URLs.

`--query-param-names`
: Parses the query param names from all spidered URLs.

`--query-param-values`
: Parses the query param values from all spidered URLs.

`--only-paths`
: Only parse the directory names from all spidered URLs.

`--only-query-param-names`
: Only parse the query param names from all spidered URLs.

`--query-param-values`
: Only parse the query param values from all spidered URLs.

`-f`, `--format` `txt`|`gz`|`bzip2`|`xz`
: Specifies the format of the wordlist file that will be created.

`-A`, `--append`
: Append new words to an existing wordlist file instead of overwriting the file.

### TEXT PARSING OPTIONS

`-L`, `--lang` *LANG*
: The language of the text to parse. Defaults to the current language set by the
  `LANG` environment variable.

`--stop-word` *WORD*
: Defines a custom "stop word" (ex: "the", "is", "a") to be ignored.
  If not specified, a default list of "stop words" will be selected based on
  either `--lang` or the current language set by the `LANG` environment
  variable.

`--ignore-word` *WORD*
: Adds the word to the list of words to ignore while parsing text.

`--digits`
: Accepts words contining digits (0-9) while parsing text. This is the default
  behavior.

`--no-digits`
: Ignores words containing digits (0-9) while parsing text.

`--special-char` *CHAR*
: Allows a specific special character to exist within words. If not specified,
  only the characters `_`, `-`, `'` are allowed by default.

`--numbers`
: Accepts whole numbers as words while parsing text.

`--no-numbers`
: Ignores whole numbers while parsing text. This is the default behavior.

`--acronyms`
: Treat acronyms (ex: `A.B.C.`) as words while parsing text.
  This is the default behavior.

`--no-acronyms`
: Ignores acronyms (ex: `A.B.C.`) while parsing text.

`--normalize-case`
: Converts all words to lowercase while parsing text.

`--no-normalize-case`
: Preserves the case of words letters while parsing text. This is the default
  behavior. This is the default behavior.

`--normalize-apostrophes`
: Removes apostrophes from words (ex: `It's` -> `Its`) while parsing text.

`--no-normalize-apostrophes`
: Preserves apostrophes in words (ex: `It's`). This is the default behavior.
  This is the default behavior.

`--normalize-acronyms`
: Removes the periods from acronyms (ex: `A.B.C.` -> `ABC`) while parsing text.

`--no-normalize-acronyms`
: Preserves the periods in acronyms (ex: `A.B.C.`) while parsing text.
  This is the default behavior.

`-h`, `--help`
: Print help information.

### SPIDER OPTIONS

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

`-H`, `--header` "*NAME*`:` *VALUE*"
: Sets a default header.

`--host-header` *NAME*=*VALUE*
: Sets a default header.

`-u`, `--user-agent` `chrome-linux`|`chrome-macos`|`chrome-windows`|`chrome-iphone`|`chrome-ipad`|`chrome-android`|`firefox-linux`|`firefox-macos`|`firefox-windows`|`firefox-iphone`|`firefox-ipad`|`firefox-android`|`safari-macos`|`safari-iphone`|`safari-ipad`|`edge`
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

`--host` *HOST*
: Spiders the specific *HOST*.

`--domain` *DOMAIN*
: Spiders the whole *DOMAIN*.

`--site` *URL*
: Spiders the website, starting at the *URL*.

## ENVIRONMENT

*HTTP_PROXY*
: Sets the global HTTP proxy.

*RONIN_HTTP_PROXY*
: Sets the HTTP proxy for Ronin.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-web-spider](ronin-web-spider.1.md)