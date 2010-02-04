#
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

require 'ronin/network/helpers/helper'
require 'ronin/network/http/proxy'
require 'ronin/web/web'

module Ronin
  module Network
    module Helpers
      module Web
        include Helper

        protected

        #
        # Combines the proxy information set by the `@web_proxy_host`,
        # `@web_proxy_port`, `@web_proxy_user` and `@web_proxy_password`
        # instance variables.
        #
        # @return [Network::HTTP::Proxy]
        #   The current proxy information.
        #
        def web_proxy
          HTTP::Proxy.new(
            :host => @web_proxy_host,
            :port => @web_proxy_port,
            :user => @web_proxy_user,
            :password => @web_proxy_password
          )
        end

        #
        # Provides a persistant Mechanize agent.
        #
        # @param [Hash] options
        #   Additional options for initializing the agent.
        #
        # @option options [Hash] :proxy (web_proxy)
        #   Proxy information.
        #
        # @option options [String] :user_agent (`@web_user_agent`)
        #   User-Agent string to use.
        #
        # @return [WWW::Mechanize]
        #   The agent.
        #
        def web_agent(options={},&block)
          unless @web_agent
            options[:proxy] ||= web_proxy
            options[:user_agent] ||= @web_user_agent

            @web_agent = Ronin::Web.agent(options,&block)
          end

          return @web_agent
        end

        #
        # Creates a Mechanize Page for the contents at a given URL.
        #
        # @param [URI::Generic, String] url
        #   The URL to request.
        #
        # @param [Hash] options
        #   Additional options to initialize the agent with.
        #
        # @option options [Hash] :proxy (web_proxy)
        #   Proxy information.
        #
        # @option options [String] :user_agent (`@web_user_agent`)
        #   User-Agent string to use.
        #
        # @yield [page]
        #   If a block is given, it will be passed the page for the
        #   requested URL.
        #
        # @yieldparam [WWW::Mechanize::Page] page
        #   The requested page.
        #
        # @return [WWW::Mechanize::Page]
        #   The requested page.
        #
        def web_get(url,options={},&block)
          page = web_agent(options).get(url)

          block.call(page) if block
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
        #   Additional options to initialize the agent with.
        #
        # @option options [Hash] :proxy (web_proxy)
        #   Proxy information.
        #
        # @option options [String] :user_agent (`@web_user_agent`)
        #   User-Agent string to use.
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
        def web_get_body(url,options={},&block)
          web_get(url,options) do |page|
            body = page.body

            block.call(body) if block
            return body
          end
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
        # @option options [String] :user_agent (`@web_user_agent`)
        #   User-Agent string to use.
        #
        # @yield [page]
        #   If a block is given, it will be passed the page for the
        #   requested URL.
        #
        # @yieldparam [WWW::Mechanize::Page] page
        #   The requested page.
        #
        # @return [WWW::Mechanize::Page]
        #   The requested page.
        #
        def web_post(url,options={},&block)
          query = {}
          query.merge!(options[:query]) if options[:query]

          page = web_agent(options).post(url)

          block.call(page) if block
          return page
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
        # @option options [String] :user_agent (`@web_user_agent`)
        #   User-Agent string to use.
        #
        # @yield [body]
        #   If a block is given, it will be passed the body of the page.
        #
        # @yieldparam [WWW::Mechanize::Page] page
        #   The body of the requested page.
        #
        # @return [String]
        #   The requested body of the page.
        #
        def web_post_body(url,options={},&block)
          web_post(url,options) do |page|
            body = page.body

            block.call(body) if block
            return body
          end
        end
      end
    end
  end
end
