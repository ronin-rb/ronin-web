#
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/network/mixins/mixin'
require 'ronin/network/http/proxy'
require 'ronin/ui/output/helpers'
require 'ronin/web/mechanize'

module Ronin
  module Network
    module Mixins
      #
      # Network helper methods that use {Web::Mechanize}.
      #
      module Web
        include Mixin
 
        # The Web Proxy host to connect to
        parameter :web_proxy_host, type:        String,
                                   description: 'Web Proxy host'

        # The Web Proxy port to connect to
        parameter :web_proxy_port, type:        Integer,
                                   description: 'Web Proxy port'

        # The Web Proxy user to authenticate with
        parameter :web_proxy_user, type:        String,
                                   description: 'Web Proxy authentication user'

        # The Web Proxy password to authenticate with
        parameter :web_proxy_password, type:        String,
                                       description: 'Web Proxy authentication password'

        #
        # Combines the proxy information set by the {#web_proxy_host},
        # {#web_proxy_port}, {#web_proxy_user} and {#web_proxy_password}
        # parameters.
        #
        # @return [Network::HTTP::Proxy]
        #   The current proxy information.
        #
        # @api semipublic
        #
        def web_proxy
          HTTP::Proxy.new(
            host:     @web_proxy_host,
            port:     @web_proxy_port,
            user:     @web_proxy_user,
            password: @web_proxy_password
          )
        end

        #
        # Provides a persistent Mechanize agent.
        #
        # @param [Hash] options
        #   Additional options for initializing the agent.
        #
        # @option options [Hash] :proxy (web_proxy)
        #   Proxy information.
        #
        # @option options [String] :user_agent (web_user_agent)
        #   User-Agent string to use.
        #
        # @return [Mechanize]
        #   The agent.
        #
        # @api semipublic
        #
        def web_agent(options={},&block)
          @web_agent ||= Web::Mechanize.new({
            proxy:       web_proxy,
            user_agent:  @web_user_agent
          }.merge(options),&block)
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
        #   If a block is given, it will be passed the page for the
        #   requested URL.
        #
        # @yieldparam [Mechanize::Page] page
        #   The requested page.
        #
        # @return [Mechanize::Page]
        #   The requested page.
        #
        # @api semipublic
        #
        def web_get(url,parameters={},headers={},&block)
          print_info "Requesting #{url}"
          headers.each { |name,value| print_debug "  #{name}: #{value}" }

          return web_agent(options).get(url,parameters,headers,&block)
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
        # @api semipublic
        #
        def web_get_body(url,options={})
          page = web_get(url,options)
          body = page.body

          yield body if block_given?
          return body
        end

        #
        # Posts to a given URL and creates a Mechanize Page from the
        # response.
        #
        # @param [URI::Generic, String] url
        #   The URL to post to.
        #
        # @param [Hash] options
        #   Additional options to initialize the agent with.
        #
        # @option options [Hash] :query
        #   Additional query parameters to post with.
        #
        # @option options [Hash] :proxy (web_proxy)
        #   Proxy information.
        #
        # @option options [String] :user_agent (web_user_agent)
        #   User-Agent string to use.
        #
        # @yield [page]
        #   If a block is given, it will be passed the page for the
        #   requested URL.
        #
        # @yieldparam [Mechanize::Page] page
        #   The requested page.
        #
        # @return [Mechanize::Page]
        #   The requested page.
        #
        # @api semipublic
        #
        def web_post(url,parameters={},headers={},&block)
          print_info "Posting #{url}"
          headers.each { |name,value| print_debug "  #{name}: #{value}" }

          return web_agent(options).post(url,parameters,headers,&block)
        end

        #
        # Posts to a given URL and returns the body of the Mechanize Page
        # created from the response.
        #
        # @param [URI::Generic, String] url
        #   The URL to post to.
        #
        # @param [Hash] options
        #   Additional options to initialize the agent with.
        #
        # @option options [Hash] :query
        #   Additional query parameters to post with.
        #
        # @option options [Hash] :proxy (web_proxy)
        #   Proxy information.
        #
        # @option options [String] :user_agent (web_user_agent)
        #   User-Agent string to use.
        #
        # @yield [body]
        #   If a block is given, it will be passed the body of the page.
        #
        # @yieldparam [Mechanize::Page] page
        #   The body of the requested page.
        #
        # @return [String]
        #   The requested body of the page.
        #
        # @api semipublic
        #
        def web_post_body(url,options={})
          page = web_post(url,options)
          body = page.body

          yield body if block_given?
          return body
        end
      end
    end
  end
end
