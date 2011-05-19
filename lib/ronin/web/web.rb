#
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Web.
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
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/network/http/proxy'
require 'ronin/network/http/http'

require 'uri/http'
require 'nokogiri'
require 'mechanize'
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
    # @return [Nokogiri::HTML::Document] The new HTML document object.
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
    #         div(:style => 'display:none;') {
    #           object(:classid => 'blabla')
    #         }
    #       }
    #     }
    #   end
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
    # @return [Nokogiri::XML::Document] The new XML document object.
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
    #    post(:id => 2) {
    #      title { text('some example') }
    #      body { text('this is one contrived example.') }
    #    }
    #  end
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
    # @see Ronin::Network::HTTP.proxy
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
    # @since 0.4.0
    #
    def Web.proxy=(new_proxy)
      @proxy = Network::HTTP::Proxy.create(new_proxy)
    end

    #
    # @return [Array]
    #   The supported Web User-Agent Aliases.
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
    def Web.user_agent
      (@user_agent ||= nil) || Network::HTTP.user_agent
    end

    #
    # Sets the User-Agent string used by {Web}.
    #
    # @param [String] new_agent
    #   The User-Agent string to use.
    #
    # @return [String]
    #   The new User-Agent string.
    #
    def Web.user_agent=(new_agent)
      @user_agent = new_agent
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
    def Web.user_agent_alias=(name)
      @user_agent = Web.user_agent_aliases[name.to_s]
    end

    #
    # Opens a URL as a temporary file.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [String] :user_agent_alias
    #   The User-Agent Alias to use.
    #
    # @option options [String] :user_agent
    #   The User-Agent string to use.
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
    #     :user_agent_alias => 'Linux Mozilla')
    #
    # @example Open a given URL, using a custom User-Agent string.
    #   Web.open('http://www.wired.com/', :user_agent => 'the future')
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
    # Creates a new Mechanize Agent.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [String] :user_agent_alias
    #   The User-Agent Alias to use.
    #
    # @option options [String] :user_agent
    #   The User-Agent string to use.
    #
    # @option options [Network::HTTP::Proxy, Hash, String] :proxy
    #   (Web.proxy)
    #   Proxy information.
    #
    # @yield [agent]
    #   If a block is given, it will be passed the newly created Mechanize
    #   agent.
    #
    # @yieldparam [Mechanize] agent
    #   The new Mechanize agent.
    #
    # @return [Mechanize]
    #   The new Mechanize agent.
    #
    # @example Create a new agent.
    #   Web.agent
    #
    # @example Create a new agent, with a custom User-Agent alias.
    #   Web.agent(:user_agent_alias => 'Linux Mozilla')
    #
    # @example Create a new agent, with a custom User-Agent string.
    #   Web.agent(:user_agent => 'wooden pants')
    #
    # @see http://mechanize.rubyforge.org/mechanize/Mechanize.html
    #
    def Web.agent(options={})
      agent = Mechanize.new

      if options[:user_agent_alias]
        agent.user_agent_alias = options[:user_agent_alias]
      elsif options[:user_agent]
        agent.user_agent = options[:user_agent]
      elsif Web.user_agent
        agent.user_agent = Web.user_agent
      end

      proxy = Network::HTTP::Proxy.new(options[:proxy] || Web.proxy)

      if proxy[:host]
        agent.set_proxy(
          proxy[:host],
          proxy[:port],
          proxy[:user],
          proxy[:password]
        )
      end

      yield agent if block_given?
      return agent
    end

    #
    # Creates a Mechanize Page for the contents at a given URL.
    #
    # @param [URI::Generic, String] url
    #   The URL to request.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [String] :user_agent_alias
    #   The User-Agent Alias to use.
    #
    # @option options [String] :user_agent
    #   The User-Agent string to use.
    #
    # @option options [Network::HTTP::Proxy, Hash] :proxy (Web.proxy)
    #   Proxy information.
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
    # @see http://mechanize.rubyforge.org/mechanize/Mechanize/Page.html
    #
    def Web.get(url,options={})
      page = Web.agent(options).get(url)

      yield page if block_given?
      return page
    end

    #
    # Requests the body of the Mechanize Page created from the response
    # of the given URL.
    #
    # @param [URI::Generic, String] url
    #   The URL to request.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [String] :user_agent_alias
    #   The User-Agent Alias to use.
    #
    # @option options [String] :user_agent
    #   The User-Agent string to use.
    #
    # @option options [Network::HTTP::Proxy, Hash] :proxy (Web.proxy)
    #   Proxy information.
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
    def Web.get_body(url,options={})
      body = Web.get(url,options).body

      yield body if block_given?
      return body
    end

    #
    # Posts to a given URL and creates a Mechanize Page from the response.
    #
    # @param [URI::Generic, String] url
    #   The URL to request.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [Hash] :query
    #   Additional query parameters to post with.
    #
    # @option options [String] :user_agent_alias
    #   The User-Agent Alia to use.
    #
    # @option options [String] :user_agent
    #   The User-Agent string to use.
    #
    # @option options [Network::HTTP::Proxy, Hash] :proxy (Web.proxy)
    #   Proxy information.
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
    def Web.post(url,options={})
      query = {}
      query.merge!(options[:query]) if options[:query]

      page = Web.agent(options).post(url,query)

      yield page if block_given?
      return page
    end

    #
    # Posts to a given URL and returns the body of the Mechanize Page
    # created from the response.
    #
    # @param [URI::Generic, String] url
    #   The URL to request.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [Hash] :query
    #   Additional query parameters to post with.
    #
    # @option options [String] :user_agent_alias
    #   The User-Agent Alias to use.
    #
    # @option options [String] :user_agent
    #   The User-Agent string to use.
    #
    # @option options [Network::HTTP::Proxy, Hash] :proxy (Web.proxy)
    #   Proxy information.
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
    def Web.post_body(url,options={})
      body = Web.post(url,options).body

      yield body if block_given?
      return body
    end
  end
end
