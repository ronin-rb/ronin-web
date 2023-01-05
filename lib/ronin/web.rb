#
# ronin-web - A collection of useful web helper methods and commands.
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# ronin-web is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-web is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with ronin-web.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/web/html'
require 'ronin/web/xml'
require 'ronin/web/spider'
require 'ronin/web/server'
require 'ronin/web/user_agents'
require 'ronin/web/mechanize'
require 'ronin/web/version'
require 'ronin/support/network/http'

require 'uri'
require 'open-uri'
require 'nokogiri'
require 'nokogiri/ext'
require 'nokogiri/diff'
require 'open_namespace'

module Ronin
  module Web
    include OpenNamespace

    #
    # Parses the body of a document into a HTML document object.
    #
    # @param [String, IO] body
    #   The body of the document to parse.
    #
    # @yield [doc]
    #   If a block is given, it will be passed the newly created document
    #   object.
    #
    # @yieldparam [Nokogiri::HTML::Document] doc
    #   The new HTML document object.
    #
    # @return [Nokogiri::HTML::Document]
    #   The new HTML document object.
    #
    # @see http://rubydoc.info/gems/nokogiri/Nokogiri/HTML/Document
    #
    # @api public
    #
    def self.html(body,&block)
      HTML.parse(body,&block)
    end

    #
    # Creates a new Nokogiri::HTML::Builder.
    #
    # @yield []
    #   The block that will be used to construct the HTML document.
    #
    # @return [Nokogiri::HTML::Builder]
    #   The new HTML builder object.
    #
    # @example
    #   Web.build_html do
    #     html {
    #       body {
    #         div(style: 'display:none;') {
    #           object(classid: 'blabla')
    #         }
    #       }
    #     }
    #   end
    #
    # @see http://rubydoc.info/gems/nokogiri/Nokogiri/HTML/Builder
    #
    # @api public
    #
    def self.build_html(&block)
      HTML.build(&block)
    end

    #
    # Parses the body of a document into a XML document object.
    #
    # @param [String, IO] body
    #   The body of the document to parse.
    #
    # @yield [doc]
    #   If a block is given, it will be passed the newly created document
    #   object.
    #
    # @yieldparam [Nokogiri::XML::Document] doc
    #   The new XML document object.
    #
    # @return [Nokogiri::XML::Document]
    #   The new XML document object.
    #
    # @see http://rubydoc.info/gems/nokogiri/Nokogiri/XML/Document
    #
    # @api public
    #
    def self.xml(body,&block)
      XML.parse(body,&block)
    end

    #
    # Creates a new Nokogiri::XML::Builder.
    #
    # @yield []
    #   The block that will be used to construct the XML document.
    #
    # @return [Nokogiri::XML::Builder]
    #   The new XML builder object.
    #
    # @example
    #  Web.build_xml do
    #    post(id: 2) {
    #      title { text('some example') }
    #      body { text('this is one contrived example.') }
    #    }
    #  end
    #
    # @see http://rubydoc.info/gems/nokogiri/Nokogiri/XML/Builder
    #
    # @api public
    #
    def self.build_xml(&block)
      XML.build(&block)
    end

    #
    # Opens a URL as a temporary file.
    #
    # @param [String, :random, :chrome, :chrome_linux, :chrome_macos,
    #         :chrome_windows, :chrome_iphone, :chrome_ipad,
    #         :chrome_android, :firefox, :firefox_linux, :firefox_macos,
    #         :firefox_windows, :firefox_iphone, :firefox_ipad,
    #         :firefox_android, :safari, :safari_macos, :safari_iphone,
    #         :safari_ipad, :edge, :linux, :macos, :windows, :iphone,
    #         :ipad, :android, nil] user_agent
    #   The `User-Agent` string to use.
    #
    # @param [String, URI::HTTP, nil] proxy
    #   The proxy URI to use.
    #
    # @param [String, URI::HTTP, nil] referer
    #   The optional `Referer` header to send.
    #
    # @param [String, Ronin::Support::Network::HTTP::Cookie, nil] cookie
    #   The optional `Cookie` header to send.
    #
    # @param [Hash{Symbol => Object}] kwargs
    #   Additional keyword arguments.
    #
    # @option kwargs [String] :user
    #   The HTTP Basic Authentication user name.
    #
    # @option kwargs [String] :password
    #   The HTTP Basic Authentication password.
    #
    # @option kwargs [Proc] :content_length_proc
    #   A callback which will be passed the content-length of the HTTP
    #   response.
    #
    # @option kwargs [Proc] :progress_proc
    #   A callback which will be passed the size of each fragment, once
    #   received from the server.
    #
    # @return [File]
    #   The contents of the URL.
    #
    # @example Open a given URL.
    #   Web.open('https://www.example.com/')
    #
    # @example Open a given URL, using a built-in User-Agent:
    #   Web.open('https://www.example.com/', user_agent: :linux)
    #
    # @example Open a given URL, using a custom User-Agent string:
    #   Web.open('https://www.example.com/', user_agent: '...')
    #
    # @example Open a given URL, using a custom User-Agent string.
    #   Web.open('https://www.example.com/', user_agent: 'the future')
    #
    # @see http://rubydoc.info/stdlib/open-uri
    #
    # @api public
    #
    def self.open(url, proxy:      Support::Network::HTTP.proxy,
                       user_agent: Support::Network::HTTP.user_agent,
                       referer:    nil,
                       cookie:     nil,
                       **kwargs)
      options = {proxy: proxy, **kwargs}

      if user_agent
        options['User-Agent'] = case user_agent
                                when Symbol
                                  Support::Network::HTTP::UserAgents[user_agent]
                                else
                                  user_agent
                                end
      end

      options['Referer'] = referer if referer
      options['Cookie']  = cookie  if cookie

      return URI.open(url,options)
    end

    #
    # A persistent Mechanize Agent.
    #
    # @return [Mechanize]
    #   The persistent Mechanize Agent.
    #
    # @see Mechanize
    #
    # @api public
    #
    def self.agent
      @agent ||= Mechanize.new
    end

    #
    # Creates a Mechanize Page for the contents at a given URL.
    #
    # @param [URI::Generic, String] url
    #   The URL to request.
    #
    # @param [Array, Hash] parameters
    #   Additional parameters for the GET request.
    #
    # param [Hash] headers
    #   Additional headers for the GET request.
    #
    # @yield [page]
    #   If a block is given, it will be passed the page for the requested
    #   URL.
    #
    # @yieldparam [Mechanize::Page] page
    #   The requested page.
    #
    # @return [Mechanize::Page]
    #   The requested page.
    #
    # @example
    #   Web.get('http://www.rubyinside.com')
    #   # => Mechanize::Page
    #
    # @example
    #   Web.get('http://www.rubyinside.com') do |page|
    #     page.search('div.post/h2/a').each do |title|
    #       puts title.inner_text
    #     end
    #   end
    #
    # @see http://rubydoc.info/gems/mechanize/Mechanize/Page
    #
    # @api public
    #
    def self.get(url,parameters={},headers={},&block)
      agent.get(url,parameters,nil,headers,&block)
    end

    #
    # Requests the body of the Mechanize Page created from the response
    # of the given URL.
    #
    # @param [URI::Generic, String] url
    #   The URL to request.
    #
    # @param [Array, Hash] parameters
    #   Additional parameters for the GET request.
    #
    # param [Hash] headers
    #   Additional headers for the GET request.
    #
    # @yield [body]
    #   If a block is given, it will be passed the body of the page.
    #
    # @yieldparam [String] body
    #   The requested body of the page.
    #
    # @return [String]
    #   The requested body of the page.
    #
    # @example
    #   Web.get_body('http://www.rubyinside.com') # => String
    #
    # @example
    #   Web.get_body('http://www.rubyinside.com') do |body|
    #     puts body
    #   end
    #
    # @see get
    #
    # @api public
    #
    def self.get_body(url,parameters={},headers={})
      body = get(url,parameters,headers).body

      yield body if block_given?
      return body
    end

    #
    # Posts to a given URL and creates a Mechanize Page from the response.
    #
    # @param [URI::Generic, String] url
    #   The URL to request.
    #
    # @param [Hash] query
    #   Additional query parameters for the POST request.
    #
    # @param [Hash] headers
    #   Additional headers for the POST request.
    #
    # @yield [page]
    #   If a block is given, it will be passed the page for the requested
    #   URL.
    #
    # @yieldparam [Mechanize::Page] page
    #   The requested page.
    #
    # @return [Mechanize::Page]
    #   The requested page.
    #
    # @example
    #   Web.post('http://www.rubyinside.com')
    #   # => Mechanize::Page
    #
    # @see http://rubydoc.info/gems/mechanize/Mechanize/Page
    #
    # @api public
    #
    def self.post(url,query={},headers={},&block)
      agent.post(url,query,headers={},&block)
    end

    #
    # Posts to a given URL and returns the body of the Mechanize Page
    # created from the response.
    #
    # @param [URI::Generic, String] url
    #   The URL to request.
    #
    # @param [Hash] query
    #   Additional query parameters for the POST request.
    #
    # @param [Hash] headers
    #   Additional headers for the POST request.
    #
    # @yield [body]
    #   If a block is given, it will be passed the body of the page.
    #
    # @yieldparam [Mechanize::Page] page
    #   The body of the requested page.
    #
    # @return [Mechanize::Page]
    #   The body of the requested page.
    #
    # @example
    #   Web.post_body('http://www.rubyinside.com')
    #   # => String
    #
    # @example
    #   Web.post_body('http://www.rubyinside.com') do |body|
    #     puts body
    #   end
    #
    # @see post
    #
    # @api public
    #
    def self.post_body(url,query={},headers={})
      body = post(url,query,headers).body

      yield body if block_given?
      return body
    end
  end
end
