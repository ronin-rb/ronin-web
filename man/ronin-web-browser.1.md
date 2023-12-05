# ronin-web-browser 1 "2022-01-01" Ronin Web "User Manuals"

## NAME

ronin-web-browser - Automates a web browser

## SYNOPSIS

`ronin-web-browser` [*options*] [*URL*]

## DESCRIPTION

Starts an automated web browser.

## ARGUMENTS

*URL*
: The initial URL to visit.

## OPTIONS

`-B`, `--browser` *NAME*\|*PATH*
: The browser name or path to execute.

`-W`, `--width` *WIDTH*
: Sets the width of the browser viewport. Defaults to `1024` if not given.

`-H`, `--height` *HEIGHT*
: Sets the height of the browser viewport. Defaults to `768` if not given.

`--headless`
: Run the browser in headless mode.

`--visible`
: Open a visible browser.

`-x`, `--x` *INT*
: Sets the position of the browser window's X coordinate.

`-y`, `--y` *INT*
: Sets the position of the browser window's Y coordinate.

`--inject-js` *JS*
: Injects the JavaScript code into every page.

`--inject-js-file` *FILE*
: Injects the JavaScript file code into every page.

`--bypass-csp`
: Enables bypassing Content-Security-Policy (CSP).

`--print-urls`
: Print every requested URL.

`--print-status`
: Print the status of all requested URLs.

`--print-requests`
: Prints every request sent by the browser.

`--print-responses`
: Prints every response received by the browser.

`--print-traffic`
: Print both requests and responses.

`--print-headers`
: Also print headers of requests and responses.

`--print-body`
: Also print the bodies of the requests and responses.

`--shell`
: Starts an interactive shell for the browser.

`--js-shell`
: Starts an interactive JavaScript shell.

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

[ronin-web-screenshot](ronin-web-screenshot.1.md)