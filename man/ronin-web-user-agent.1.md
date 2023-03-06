# ronin-web-user-agent 1 "2023-03-01" Ronin "User Manuals"

## SYNOPSIS

`ronin-web user-agent` [*options*]

## DESCRIPTION

Generates a random HTTP `User-Agent` string.

## OPTIONS

`-B`, `--browser` `chrome`\|`firefox`
  Selects the desired browser type for the `User-Agent` string.

`--chrome-version` *VERSION*
  Sets desired Chrome version. Only takes effect when `--browser chrome` is also
  given.

`--firefox-version` *VERSION*
  Sets desired Firefox version. Only takes effect when `--browser chrome` is
  also given.

`-D`, `--linux-distro` `ubuntu`\|`fedora`\|`arch`\|`DISTRO`
  Selects the desired Linux distro.

`-A`, `--arch` `x86-64`\|`x86`\|`i686`\|`aarch64`\|`arm64`\|`arm`
  Selects the desired architecture.

`-O`, `--os` `android`\|`linux`\|`windows`
  Selects the desired OS.

`--os-version` *VERSION*
  Sets the desired OS version.

`-h`, `--help`
  Print help information.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

