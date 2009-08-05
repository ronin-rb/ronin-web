= Ronin Web

* http://ronin.rubyforge.org/web/
* http://github.com/postmodern/ronin-web
* irc.freenode.net ##ronin
* Postmodern (postmodern.mod3 at gmail.com)

== DESCRIPTION:

Ronin Web is a Ruby library for Ronin that provides support for web
scraping and spidering functionality.

Ronin is a Ruby platform designed for information security and data
exploration tasks. Ronin allows for the rapid development and distribution
of code over many of the common Source-Code-Management (SCM) systems.

=== Free

All source code within Ronin is licensed under the GPL-2, therefore no user
will ever have to pay for Ronin or updates to Ronin. Not only is the
source code free, the Ronin project will not sell enterprise grade security
snake-oil solutions, give private training classes or later turn Ronin into
commercial software.

=== Modular

Ronin was not designed as one monolithic framework but instead as a
collection of libraries which can be individually installed. This allows
users to pick and choose what functionality they want in Ronin.

=== Decentralized

Ronin does not have a central repository of exploits and payloads which
all developers contribute to. Instead Ronin has Overlays, repositories of
code that can be hosted on any CVS/SVN/Git/Rsync server. Users can then use
Ronin to quickly install or update Overlays. This allows developers and
users to form their own communities, independent of the main developers
of Ronin.

== FEATURES/PROBLEMS:

* Web access (utilizing Mechanize and Nokogiri).
* Integrates Spidr into Ronin::Web::Spider.
* Provides Ronin::Web::Server, a customizable Rack based Web Server that
  supports path and host-name routing.
* Provides Ronin::Web::Proxy, a configurable Rack based Web Proxy.

== REQUIREMENTS:

* {nokogiri}[http://nokogiri.rubyforge.org/] >= 1.1.0
* {mechanize}[http://mechanize.rubyforge.org/] >= 0.9.0
* {spidr}[http://spidr.rubyforge.org/] >= 0.1.3
* {rack}[http://rack.rubyforge.org/] >= 0.9.1
* {ronin}[http://ronin.rubyforge.org/] >= 0.2.2

== INSTALL:

  $ sudo gem install ronin-web

== SYNOPSIS:

* Start the Ronin console with Ronin Web preloaded:

    $ ronin-web

== EXAMPLES:

* Get a web-page:

    Web.get('http://www.example.com/')

* Get only the body of the web-page:

    Web.get_body('http://www.example.com/')

* Get a WWW::Mechanize agent:

    agent = Web.agent

* Parse HTML:

    Web.html(open('some_file.html'))
    # => <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
    <html>
      <head>
        <script type="text/javascript" src="redirect.js"></script>
      </head>
    </html>

* Build a HTML document:

    doc = Web.build_html do
      html {
        head {
          script(:type => 'text/javascript', :src => 'redirect.js')
        }
      }
    end
    
    puts doc.to_html
    <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
    <html><head><script src="redirect.js" type="text/javascript"></script></head></html>

* Parse XML:

    Web.xml(some_text)
    => <?xml version="1.0"?>
    <users>
      <user>
        <name>admin</name>
        <password>0mni</password>
      </user>
    </users>


* Build a XML document:

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
    <?xml version="1.0"?>
    <playlist>
      <mp3>
        <file>02 THE WAIT.mp3</file>
        <artist>Evil Nine</artist>
        <track>The Wait feat David Autokratz</track>
        <duration>1000000000</duration>
      </mp3>
    </playlist>

* Spider a web site:

    Web::Spider.host('www.example.com') do |spider|
      spider.every_url do |url|
        ...
      end

      spider.every_page do |page|
        ...
      end
    end

* Serve files via a Web Server:

    Web.server do
      file '/opensearch.xml', '/tmp/test.xml'
      directory '/download/', '/tmp/download/'
    end

    Web.server.get '/test' do
      'Test 1 2 1 2'
    end

== LICENSE:

Ronin Web - A Ruby library for Ronin that provides support for web
scraping and spidering functionality.

Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)

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
