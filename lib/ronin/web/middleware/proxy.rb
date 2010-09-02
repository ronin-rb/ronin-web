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

require 'ronin/web/middleware/base'
require 'ronin/web/middleware/rule'
require 'ronin/web/middleware/proxy_request'

require 'ronin/network/http'
require 'set'

module Ronin
  module Web
    module Middleware
      #
      # A Rack middleware for proxying requests.
      #
      #     use Ronin::Web::Middleware::Proxy do |proxy|
      #       proxy.every_request do |request|
      #         puts request.url
      #       end
      #
      #       proxy.every_response do |response|
      #         response.headers.each do |name,value|
      #           puts "#{name}: #{value}"
      #         end
      #
      #         puts response.body
      #       end
      #     end
      #
      class Proxy < Base

        # Blacklisted HTTP response Headers.
        HEADERS_BLACKLIST = Set[
          'Transfer-Encoding'
        ]

        #
        # Creates a new {Proxy} middleware.
        #
        # @param [#call] app
        #   The application that the proxy middleware sits in front of.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [String] :campaign
        #   The name of the campaign who's targetted hosts will be
        #   filtered by.
        #
        # @option options [String, Regexp] :vhost
        #   The Virtual-Host to filter.
        #
        # @option options [String, IPAddr] :ip
        #   The IP address or IP range to filter.
        #
        # @option options [String, Regexp] :referer
        #   The Referer URL or pattern to filter.
        #
        # @option options [String, Regexp] :user_agent
        #   The User-Agent string to filter.
        #
        # @option options [Proc] :when
        #   Custom logic to filter requests by.
        #
        # @yield [proxy]
        #   If a block is given, it will be passed the new proxy middleware.
        #
        # @yieldparam [Proxy] proxy
        #   The new proxy middleware object.
        #
        # @since 0.3.0
        #
        def initialize(app,options={},&block)
          intercept(options)

          super(app,options,&block)
        end

        #
        # Specifies which requests will be intercepted.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [String] :campaign
        #   The name of the campaign who's targetted hosts will be
        #   filtered by.
        #
        # @option options [String, Regexp] :vhost
        #   The Virtual-Host to filter.
        #
        # @option options [String, IPAddr] :ip
        #   The IP address or IP range to filter.
        #
        # @option options [String, Regexp] :referer
        #   The Referer URL or pattern to filter.
        #
        # @option options [String, Regexp] :user_agent
        #   The User-Agent string to filter.
        #
        # @option options [Proc] :when
        #   Custom logic to filter requests by.
        #
        # @since 0.3.0
        #
        def intercept(options={})
          @rule = Rule.new(options)
        end

        #
        # Uses the given block to intercept incoming requests.
        #
        # @yield [request]
        #   The given block will receive every incoming request, before it
        #   is proxied.
        #
        # @yieldparam [ProxyRequest] request
        #   A proxied request.
        #
        # @return [Proxy]
        #   The proxy middleware.
        #
        # @since 0.3.0
        #
        def every_request(&block)
          @every_request_block = block
          return self
        end

        #
        # Uses the given block to intercept proxied responses.
        #
        # @yield [response]
        #   The given block will receive every proxied response.
        #
        # @yieldparam [Response] response
        #   A proxied response.
        #
        # @return [Proxy]
        #   The proxy middleware.
        #
        # @since 0.3.0
        #
        def every_response(&block)
          @every_response_block = block
          return self
        end

        #
        # Receives incoming requests, proxies them, allowing manipulation
        # of the requests and their responses.
        #
        # @param [Hash, Rack::Request] env
        #   The request.
        #
        # @return [Array, Response]
        #   The response.
        #
        # @since 0.3.0
        #
        def call(env)
          request = ProxyRequest.new(env)

          if @rule.match?(request)
            @every_request_block.call(request) if @every_request_block
          else
            return super(env)
          end

          print_info "Proxying #{request.url}"
          request.headers.each do |name,value|
            print_debug "  #{name}: #{value}"
          end

          response = proxy(request)

          @every_response_block.call(response) if @every_response_block

          print_info "Returning proxied response."
          response.headers.each do |name,value|
            print_debug "  #{name}: #{value}"
          end

          return response
        end

        protected

        #
        # Proxies a request.
        #
        # @param [ProxyRequest] request
        #   The request to send.
        #
        # @return [Response]
        #   The response from the request.
        #
        def proxy(request)
          options = {
            :ssl => (request.scheme == 'https'),
            :host => request.host,
            :port => request.port,
            :method => request.request_method,
            :path => request.path_info,
            :query => request.query_string,
            :content_type => request.content_type,
            :headers => request.headers
          }

          if request.form_data?
            options[:form_data] = request.POST
          end

          http_response = Net.http_request(options)
          http_headers = {}

          http_response.each_capitalized do |name,value|
            unless HEADERS_BLACKLIST.include?(name)
              http_headers[name] = value
            end
          end

          return Response.new(
            (http_response.body || ''),
            http_response.code,
            http_headers,
          )
        end

      end
    end
  end
end
