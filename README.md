# ronin-web

[![CI](https://github.com/ronin-rb/ronin-web/actions/workflows/ruby.yml/badge.svg)](https://github.com/ronin-rb/ronin-web/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/ronin-rb/ronin-web.svg)](https://codeclimate.com/github/ronin-rb/ronin-web)

* [Source](https://github.com/ronin-rb/ronin-web)
* [Issues](https://github.com/ronin-rb/ronin-web/issues)
* [Documentation](https://ronin-rb.dev/docs/ronin-web/frames)
* [Slack](https://ronin-rb.slack.com) |
  [Discord](https://discord.gg/6WAb3PsVX9) |
  [Twitter](https://twitter.com/ronin_rb)

## Description

ronin-web is a collection of useful web helper methods and commands.

ronin-web is part of the [ronin-rb] project, a [Ruby] toolkit for security
research and development.

## Features

* HTML/XML parsing/building (using [Nokogiri][Nokogiri]).
* Automated Web Browsing (using [Mechanize][Mechanize])

## Synopsis

Start the Ronin console with Ronin Web preloaded:

```shell
$ ronin-web
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

Get a [Mechanize agent][Mechanize]:

```ruby
agent = Web.agent
```

Parse HTML:

```ruby
Web.html(open('some_file.html'))
# => <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
# <html>
#   <head>
#     <script type="text/javascript" src="redirect.js"></script>
#   </head>
# </html>
```

Build a HTML document:

```ruby
doc = Web.build_html do
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
Web.xml(some_text)
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
doc = Web.build_xml do
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

* [Ruby] >= 2.7.0
* [nokogiri] ~> 1.4
  * [libxml2]
  * [libxslt1]
* [nokogiri-ext] ~> 0.1
* [nokogiri-diff] ~> 0.2
* [mechanize] ~> 2.0
* [ronin-support] ~> 0.4
* [ronin-web-server] ~> 0.1
* [ronin-web-spider] ~> 0.1
* [ronin-web-user_agents] ~> 0.1

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

Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)

This file is part of ronin-web.

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

[Nokogiri]: http://rubydoc.info/gems/nokogiri/frames
[Mechanize]: http://rubydoc.info/gems/mechanize/frames

[ronin-rb]: https://ronin-rb.dev
[Ruby]: https://www.ruby-lang.org

[nokogiri]: https://github.com/sparklemotion/nokogiri#readme
[nokogiri-ext]: https://github.com/postmodern/nokogiri-ext#readme
[nokogiri-diff]: https://github.com/postmodern/nokogiri-diff#readme
[libxml2]: http://xmlsoft.org/
[libxslt]: http://xmlsoft.org/XSLT/
[mechanize]: https://github.com/tenderlove/mechanize#readme
[ronin-support]: https://github.com/ronin-rb/ronin-support#readme
[ronin-web-server]: https://github.com/ronin-rb/ronin-web-server#readme
[ronin-web-spider]: https://github.com/ronin-rb/ronin-web-spider#readme
[ronin-web-user_agents]: https://github.com/ronin-rb/ronin-web-user_agents#readme
[ronin]: https://github.com/ronin-rb/ronin#readme
