# Ronin Web

* [Source](https://github.com/ronin-rb/ronin-web)
* [Issues](https://github.com/ronin-rb/ronin-web/issues)
* [Documentation](https://ronin-rb.dev/docs/ronin-web/frames)
* [irc.freenode.net #ronin](https://ronin-rb.dev/irc/)

## Description

{Ronin::Web} is a Ruby library for [Ronin] that provides support for web
scraping and spidering functionality.

## Features

* HTML/XML parsing/building (using [Nokogiri][1]).
* Automated Web Browsing (using [Mechanize][2])
* Provides popular [User Agent strings][3].
* Integrates [Spidr][spidr] into
  {Ronin::Web::Spider}.
* Provides {Ronin::Web::Server}, a [Sinatra][sinatra] based Web Server.
* Provides {Ronin::Web::Proxy}, a [Sinatra][sinatra] based Web Proxy.

## Synopsis

Start the Ronin console with Ronin Web preloaded:

    $ ronin-web

## Examples

Get a web-page:

    Web.get('http://www.rubyinside.com/')

Get only the body of the web-page:

    Web.get_body('http://www.rubyinside.com/')

Get a [Mechanize agent][4]:

    agent = Web.agent

Parse HTML:

    Web.html(open('some_file.html'))
    # => <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
    # <html>
    #   <head>
    #     <script type="text/javascript" src="redirect.js"></script>
    #   </head>
    # </html>

Build a HTML document:

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

Parse XML:

    Web.xml(some_text)
    # => <?xml version="1.0"?>
    # <users>
    #   <user>
    #     <name>admin</name>
    #     <password>0mni</password>
    #   </user>
    # </users>


Build a XML document:

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

Spider a web site:

    Web::Spider.host('www.example.com') do |spider|
      spider.every_url do |url|
        # ...
      end

      spider.every_page do |page|
        # ...
      end
    end

Serve files via a Web Server:

    require 'ronin/web/server'

    Web.server do
      file '/opensearch.xml', '/tmp/test.xml'
      directory '/downloads/', '/tmp/downloads/'
    end

    Web.server.get '/test' do
      'Test 1 2 1 2'
    end

## Requirements

* [Ruby] >= 1.9.1
* [nokogiri] ~> 1.4
  * [libxml2]
  * [libxslt1]
* [mechanize] ~> 2.0
* [spidr] ~> 0.2
* [rack] ~> 1.3
* [sinatra] ~> 1.3
* [data\_paths] ~> 0.3
* [ronin-support] ~> 0.4
* [ronin] ~> 1.4

## Install

    $ gem install ronin-web

### Edge

    $ git clone git://github.com/ronin-rb/ronin-web.git
    $ cd ronin-web/
    $ bundle install
    $ ./bin/ronin-web

## License

Ronin Web - A Ruby library for Ronin that provides support for web
scraping and spidering functionality.

Copyright (c) 2006-2013 Hal Brodigan (postmodern.mod3 at gmail.com)

This file is part of Ronin Web.

Ronin is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Ronin is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Ronin.  If not, see <https://www.gnu.org/licenses/>.

[1]: http://rubydoc.info/gems/nokogiri/frames
[2]: http://rubydoc.info/gems/mechanize/frames
[3]: https://github.com/ronin-rb/ronin-web/blob/master/data/ronin/web/user_agents.yml
[4]: http://rubydoc.info/gems/mechanize/1.0.0/Mechanize

[Ronin]: https://ronin-rb.dev
[Ruby]: https://www.ruby-lang.org
[nokogiri]: https://github.com/tenderlove/nokogiri
[libxml2]: http://xmlsoft.org/
[libxslt]: http://xmlsoft.org/XSLT/
[mechanize]: https://github.com/tenderlove/mechanize
[spidr]: https://github.com/postmodern/spidr
[rack]: https://github.com/rack/rack
[sinatra]: https://github.com/sinatra/sinatra
[data_paths]: https://github.com/postmodern/data_paths
[ronin-support]: https://github.com/ronin-rb/ronin-support
[ronin]: https://github.com/ronin-rb/ronin
