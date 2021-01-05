#
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-web.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/web/user_agents'
require 'ronin/web/mechanize'
require 'ronin/network/http/proxy'
require 'ronin/network/http/http'

require 'uri/http'
require 'nokogiri'
require 'open-uri'

module Ronin
  module Web
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
    def Web.html(body)
      doc = Nokogiri::HTML(body)

      yield doc if block_given?
      return doc
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
    def Web.build_html(&block)
      Nokogiri::HTML::Builder.new(&block)
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
    def Web.xml(body)
      doc = Nokogiri::XML(body)

      yield doc if block_given?
      return doc
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
    def Web.build_xml(&block)
      Nokogiri::XML::Builder.new(&block)
    end

    #
    # Proxy information for {Web} to use.
    #
    # @return [Network::HTTP::Proxy]
    #   The Ronin Web proxy information.
    #
    # @see http://rubydoc.info/gems/ronin-support/Ronin/Network/HTTP#proxy-class_method
    #
    # @api public
    #
    def Web.proxy
      (@proxy ||= nil) || Network::HTTP.proxy
    end

    #
    # Sets the proxy used by {Web}.
    #
    # @param [Network::HTTP::Proxy, URI::HTTP, Hash, String] new_proxy
    #   The new proxy information to use.
    #
    # @return [Network::HTTP::Proxy]
    #   The new proxy.
    #
    # @since 0.3.0
    #
    # @api public
    #
    def Web.proxy=(new_proxy)
      @proxy = Network::HTTP::Proxy.create(new_proxy)
    end

    #
    # A set of common `User-Agent` strings.
    #
    # @return [UserAgents]
    #   The set of `User-Agent` strings.
    #
    # @since 0.3.0
    #
    # @api public
    #
    def Web.user_agents
      @user_agents ||= UserAgents.new
    end

    #
    # @return [Array]
    #   The supported Web User-Agent Aliases.
    #
    # @see http://rubydoc.info/gems/mechanize/Mechanize#AGENT_ALIASES-constant
    #
    # @deprecated
    #   Will be replaced by {user_agents} in 1.0.0.
    #
    # @api public
    #
    def Web.user_agent_aliases
      Mechanize::AGENT_ALIASES
    end

    #
    # The User-Agent string used by {Web}.
    #
    # @return [String, nil]
    #   The Ronin Web User-Agent
    #
    # @see http://rubydoc.info/gems/ronin-support/Ronin/Network/HTTP#user_agent-class_method
    #
    # @api public
    #
    def Web.user_agent
      (@user_agent ||= nil) || Network::HTTP.user_agent
    end

    #
    # Sets the `User-Agent` string used by {Web}.
    #
    # @param [String, Symbol, Regexp, nil] value
    #   The User-Agent string to use.
    #   Setting {user_agent} to `nil` will disable the `User-Agent` string.
    #
    # @return [String]
    #   The new User-Agent string.
    #
    # @raise [RuntimeError]
    #   Either no User-Agent group exists with the given `Symbol`,
    #   or no User-Agent string matched the given `Regexp`.
    #
    # @example Sets the default User-Agent
    #   Web.user_agent = 'SearchBot 2000'
    #   # => "SearchBot 2000"
    #
    # @example Select a random User-Agent with the matching sub-string
    #   Web.user_agent = 'Chrome'
    #   # => "Mozilla/5.0 (Linux; U; en-US) AppleWebKit/525.13 (KHTML, like Gecko) Chrome/0.2.149.27 Safari/525.13"
    #
    # @example Select a random User-Agent matching the Regexp
    #   Web.user_agent = /(MSIE|Windows)/
    #   # => "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; InfoPath.1)"
    #
    # @example Select a random User-Agent from a category
    #   Web.user_agent = :googlebot
    #   # => "Googlebot-Image/1.0 ( http://www.googlebot.com/bot.html)"
    #
    # @see Web.user_agents
    #
    # @api public
    #
    def Web.user_agent=(value)
      @user_agent = case value
                    when String then user_agents.fetch(value,value)
                    when nil    then nil
                    else             user_agents.fetch(value)
                    end
    end

    #
    # Sets the Ronin Web User-Agent.
    #
    # @param [String] name
    #   The User-Agent alias to use.
    #
    # @return [String]
    #   The new User-Agent string.
    #
    # @see user_agent_aliases
    #
    # @deprecated
    #   Will be replaced by calling {user_agent=} with a `Symbol`
    #   and will be removed in 1.0.0.
    #
    # @api public
    #
    def Web.user_agent_alias=(name)
      @user_agent = Web.user_agent_aliases[name.to_s]
    end

    #
    # Opens a URL as a temporary file.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [String] :user_agent
    #   The User-Agent string to use.
    #
    # @option options [String] :user_agent_alias
    #   The User-Agent Alias to use.
    #
    # @option options [Network::HTTP::Proxy, Hash, String] :proxy
    #   (Web.proxy)
    #   Proxy information.
    #
    # @option options [String] :user
    #   The HTTP Basic Authentication user name.
    #
    # @option options [String] :password
    #   The HTTP Basic Authentication password.
    #
    # @option options [Proc] :content_length_proc
    #   A callback which will be passed the content-length of the HTTP
    #   response.
    #
    # @option options [Proc] :progress_proc
    #   A callback which will be passed the size of each fragment, once
    #   received from the server.
    #
    # @return [File]
    #   The contents of the URL.
    #
    # @example Open a given URL.
    #   Web.open('http://rubyflow.com/')
    #
    # @example Open a given URL, using a custom User-Agent alias.
    #   Web.open('http://tenderlovemaking.com/',
    #     user_agent_alias: 'Linux Mozilla')
    #
    # @example Open a given URL, using a custom User-Agent string.
    #   Web.open('http://www.wired.com/', user_agent: 'the future')
    #
    # @see http://rubydoc.info/stdlib/open-uri/frames
    #
    # @api public
    #
    def Web.open(url,options={})
      user_agent_alias = options.delete(:user_agent_alias)
      proxy = Network::HTTP::Proxy.create(
        options.delete(:proxy) || Web.proxy
      )
      user = options.delete(:user)
      password = options.delete(:password)
      content_length_proc = options.delete(:content_length_proc)
      progress_proc = options.delete(:progress_proc)

      headers = Network::HTTP.headers(options)

      if user_agent_alias
        headers['User-Agent'] = Web.user_agent_aliases[user_agent_alias]
      end

      if proxy[:host]
        headers[:proxy] = proxy.url
      end

      if user
        headers[:http_basic_authentication] = [user, password]
      end

      if content_length_proc
        headers[:content_length_proc] = content_length_proc
      end

      if progress_proc
        headers[:progress_proc] = progress_proc
      end

      return Kernel.open(url,headers)
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
    def Web.agent
      @agent ||= Mechanize.new do |agent|
        agent.user_agent = Web.user_agent

        Web.proxy.tap do |proxy|
          agent.set_proxy(proxy.host,proxy.port,proxy.user,proxy.password)
        end
      end
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
    def Web.get(url,parameters={},headers={},&block)
      Web.agent.get(url,parameters,nil,headers,&block)
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
    def Web.get_body(url,parameters={},headers={})
      body = Web.get(url,parameters,headers).body

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
    def Web.post(url,query={},headers={},&block)
      Web.agent.post(url,query,headers={},&block)
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
    def Web.post_body(url,query={},headers={})
      body = Web.post(url,query,headers).body

      yield body if block_given?
      return body
    end
  end
end
