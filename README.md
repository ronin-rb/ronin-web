# Ronin Web

* [Source](http://github.com/ronin-ruby/ronin-web)
* [Issues](http://github.com/ronin-ruby/ronin-web/issues)
* [Documentation](http://rubydoc.info/github/ronin-ruby/ronin-web/frames)
* [Mailing List](http://groups.google.com/group/ronin-ruby)
* irc.freenode.net #ronin

## Description

Ronin Web is a Ruby library for Ronin that provides support for web
scraping and spidering functionality.

Ronin is a Ruby platform for exploit development and security research.
Ronin allows for the rapid development and distribution of code, exploits
or payloads over many common Source-Code-Management (SCM) systems.

### Ruby

Ronin's Ruby environment allows security researchers to leverage Ruby with
ease. The Ruby environment contains a multitude of convenience methods
for working with data in Ruby, a Ruby Object Database, a customized Ruby
Console and an extendable command-line interface.

### Extend

Ronin's more specialized features are provided by additional Ronin
libraries, which users can choose to install. These libraries can allow
one to write and run Exploits and Payloads, scan for PHP vulnerabilities,
perform Google Dorks  or run 3rd party scanners.

### Publish

Ronin allows users to publish and share code, exploits, payloads or other
data via Overlays. Overlays are directories of code and data that can be
hosted on any SVN, Hg, Git or Rsync server. Ronin makes it easy to create,
install or update Overlays.

## Features

* Web access (utilizing Mechanize and Nokogiri).
* Integrates Spidr into Ronin::Web::Spider.
* Provides a collection of useful Rack Middleware:
  * {Ronin::Web::Middleware::Files}
* Provides Ronin::Web::Server, a customizable Sinatra based Web Server that
  supports path and host-name routing.
* Provides Ronin::Web::Proxy, a configurable Sinatra based Web Proxy.

## Synopsis

Start the Ronin console with Ronin Web preloaded:

    $ ronin-web

## Examples

Get a web-page:

    Web.get('http://www.rubyinside.com/')

Get only the body of the web-page:

    Web.get_body('http://www.rubyinside.com/')

Get a Mechanize agent:

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
      directory '/download/', '/tmp/download/'
    end

    Web.server.get '/test' do
      'Test 1 2 1 2'
    end

## Requirements

* [nokogiri](http://github.com/tenderlove/nokogiri) ~> 1.4.1
  * [libxml2](http://xmlsoft.org/)
  * [libxslt1](http://xmlsoft.org/XSLT/)
* [mechanize](http://github.com/tenderlove/mechanize) ~> 1.0.0
* [data_paths](http://github.com/postmodern/data_paths) ~> 0.2.1
* [spidr](http://github.com/postmodern/spidr/) ~> 0.2.0
* [sinatra](http://github.com/sinatra/sinatra/) ~> 1.0
* [ronin-support](http://github.com/ronin-ruby/ronin-support) ~> 0.1.0
* [ronin](http://github.com/ronin-ruby/ronin) ~> 1.0.0

## Install

    $ sudo gem install ronin-web

## License

Ronin Web - A Ruby library for Ronin that provides support for web
scraping and spidering functionality.

Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
