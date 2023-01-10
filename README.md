# ronin-web

[![CI](https://github.com/ronin-rb/ronin-web/actions/workflows/ruby.yml/badge.svg)](https://github.com/ronin-rb/ronin-web/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/ronin-rb/ronin-web.svg)](https://codeclimate.com/github/ronin-rb/ronin-web)

* [Source](https://github.com/ronin-rb/ronin-web)
* [Issues](https://github.com/ronin-rb/ronin-web/issues)
* [Documentation](https://ronin-rb.dev/docs/ronin-web/frames)
* [Discord](https://discord.gg/6WAb3PsVX9) |
  [Twitter](https://twitter.com/ronin_rb) |
  [Mastodon](https://infosec.exchange/@ronin_rb)

## Description

ronin-web is a Ruby library that provides common web security commands and
additional libraries.

ronin-web is part of the [ronin-rb] project, a [Ruby] toolkit for security
research and development.

## Features

* HTML/XML parsing/building (using [Nokogiri][nokogiri]).
  * Also provides additional extensions to [Nokogiri][nokogiri] using
    [nokogiri-ext].
* Supports diffing HTML/XML documents using [nokogiri-diff].
* Automated Web Browsing using [Mechanize][mechanize].
* Supports random `User-Agent` generation using [ronin-web-user_agents].
* Provides an easy to use [Sinatra][sinatra] based web server using
  [ronin-web-server].
* Provides an easy to use web spider using [ronin-web-spider].
* Provides a CLI for common web related tasks.
* Has 98% documentation coverage.
* Has 89% test coverage.

## Synopsis

```
Usage: ronin-web [options] [COMMAND [ARGS...]]

Options:
    -h, --help                       Print help information

Arguments:
    [COMMAND]                        The command name to run
    [ARGS ...]                       Additional arguments for the command

Commands:
    diff
    help
    html
    irb
    new
    reverse-proxy
    server
    spider
```

## Examples

Get a web-page:

```ruby
Web.get('http://www.rubyinside.com/')
```

Get only the body of the web-page:

```ruby
Web.get_body('http://www.rubyinside.com/')
```

Get a [Mechanize agent][mechanize]:

```ruby
agent = Web.agent
```

Parse HTML:

```ruby
HTML.parse(open('some_file.html'))
# => <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
# <html>
#   <head>
#     <script type="text/javascript" src="redirect.js"></script>
#   </head>
# </html>
```

Build a HTML document:

```ruby
doc = HTML.build do
  html {
    head {
      script(:type => 'text/javascript', :src => 'redirect.js')
    }
  }
end

puts doc.to_html
# <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
# <html><head><script src="redirect.js" type="text/javascript"></script></head></html>
```

Parse XML:

```ruby
XML.parse(some_text)
# => <?xml version="1.0"?>
# <users>
#   <user>
#     <name>admin</name>
#     <password>0mni</password>
#   </user>
# </users>
```

Build a XML document:

```ruby
doc = XML.build do
  playlist {
    mp3 {
      file { text('02 THE WAIT.mp3') }
      artist { text('Evil Nine') }
      track { text('The Wait feat David Autokratz') }
      duration { text('1000000000') }
    }
  }
end

puts doc.to_xml
# <?xml version="1.0"?>
# <playlist>
#   <mp3>
#     <file>02 THE WAIT.mp3</file>
#     <artist>Evil Nine</artist>
#     <track>The Wait feat David Autokratz</track>
#     <duration>1000000000</duration>
#   </mp3>
# </playlist>
```

## Requirements

* [Ruby] >= 3.0.0
* [nokogiri] ~> 1.4
* [nokogiri-ext] ~> 0.1
* [nokogiri-diff] ~> 0.2
* [mechanize] ~> 2.0
* [open_namespace] ~> 0.4
* [ronin-support] ~> 1.0
* [ronin-web-server] ~> 0.1
* [ronin-web-spider] ~> 0.1
* [ronin-web-user_agents] ~> 0.1
* [ronin-core] ~> 0.1

## Install

```shell
$ gem install ronin-web
```

## Development

1. [Fork It!](https://github.com/ronin-rb/ronin-web/fork)
2. Clone It!
3. `cd ronin-web`
4. `bundle install`
5. `git checkout -b my_feature`
6. Code It!
7. `bundle exec rake spec`
8. `git push origin my_feature`

## License

ronin-web - A collection of useful web helper methods and commands.

Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)

ronin-web is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ronin-web is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with ronin-web.  If not, see <https://www.gnu.org/licenses/>.

[ronin-rb]: https://ronin-rb.dev
[Ruby]: https://www.ruby-lang.org

[nokogiri]: https://nokogiri.org/
[nokogiri-ext]: https://github.com/postmodern/nokogiri-ext#readme
[nokogiri-diff]: https://github.com/postmodern/nokogiri-diff#readme
[mechanize]: https://github.com/sparklemotion/mechanize#readme
[open_namespace]: https://github.com/postmodern/open_namespace#readme
[ronin-support]: https://github.com/ronin-rb/ronin-support#readme
[ronin-core]: https://github.com/ronin-rb/ronin-core#readme
[ronin-web-server]: https://github.com/ronin-rb/ronin-web-server#readme
[ronin-web-spider]: https://github.com/ronin-rb/ronin-web-spider#readme
[ronin-web-user_agents]: https://github.com/ronin-rb/ronin-web-user_agents#readme
[ronin]: https://github.com/ronin-rb/ronin#readme
[sinatra]: https://sinatrarb.com/
