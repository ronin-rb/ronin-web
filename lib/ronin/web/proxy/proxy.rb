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

require 'ronin/web/proxy/request'
require 'ronin/web/proxy/response'
require 'ronin/network/http'
require 'ronin/ui/output/helpers'

require 'rack/server'
require 'set'

module Ronin
  module Web
    #
    # A Rack application for proxying requests.
    #
    #     server.route '/forum/', Proxy.new do |proxy|
    #       proxy.on_request do |request|
    #         puts request.url
    #       end
    #
    #       proxy.on_response do |response|
    #         response.headers.each do |name,value|
    #           puts "#{name}: #{value}"
    #         end
    #
    #         puts response.body
    #       end
    #     end
    #
    # @since 0.3.0
    #
    # @api semipublic
    #
    class Proxy

      include Ronin::Network::HTTP
      include Ronin::UI::Output::Helpers

      # Default host the Proxy will bind to
      DEFAULT_HOST = '0.0.0.0'

      # Default port the Proxy will listen on
      DEFAULT_PORT = 8080

      # Default server the Proxy will run on
      DEFAULT_SERVER = 'webrick'

      # Blacklisted HTTP response Headers.
      HEADERS_BLACKLIST = Set[
        'Transfer-Encoding'
      ]

      #
      # Creates a new {Proxy} application.
      #
      # @yield [proxy]
      #   If a block is given, it will be passed the new proxy.
      #
      # @yieldparam [Proxy] proxy
      #   The new proxy object.
      #
      def initialize
        yield self if block_given?
      end

      #
      # The default host to bind to.
      #
      # @return [String]
      #   The host name.
      #
      def self.host
        @host ||= DEFAULT_HOST
      end

      #
      # Sets the default host.
      #
      # @param [String] new_host
      #   The new host name.
      #
      # @return [String]
      #   The new host name.
      #
      def self.host=(new_host)
        @host = new_host
      end

      #
      # The default port to listen on.
      #
      # @return [Integer]
      #   The default port number.
      #
      def self.port
        @port ||= DEFAULT_PORT
      end

      #
      # Sets the default port to listen on.
      #
      # @param [Integer] new_port
      #   The new port number.
      #
      # @return [Integer]
      #   The new port number.
      #
      def self.port=(new_port)
        @port = new_port
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
      #   The proxy app.
      #
      # @api public
      #
      def on_request(&block)
        @on_request_block = block
        return self
      end

      #
      # Uses the given block to intercept proxied responses.
      #
      # @yield [(request), response]
      #   The given block will receive every proxied response.
      #
      # @yieldparam [Request] request
      #   A proxied request.
      #
      # @yieldparam [Response] response
      #   A proxied response.
      #
      # @return [Proxy]
      #   The proxy app.
      #
      # @api public
      #
      def on_response(&block)
        @on_response_block = block
        return self
      end

      #
      # Runs the proxy as a standalone Web Server.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String] :host (DEFAULT_HOST)
      #   The host to bind to.
      #
      # @option options [Integer] :port (DEFAULT_PORT)
      #   The port to listen on.
      #
      # @option options [String] :server (DEFAULT_SERVER)
      #   The Web Server to run on.
      #
      # @option options [Boolean] :daemonize (false)
      #   Specifies whether to demonize the server.
      #
      def run!(options={})
        host = (options.delete(:host)   || self.class.host)
        port = (options.delete(:port)   || self.class.port)

        rack_options = options.merge(
          app:  self,
          Host: host,
          Port: port
        )

        server = Rack::Server.new(rack_options)

        server.start do |handler|
          trap(:INT)  { quit!(server,handler) }
          trap(:TERM) { quit!(server,handler) }

          print_info "Starting Proxy on #{host}:#{port} ..."
        end

        return self
      end

      #
      # Stops the proxy.
      #
      # @param [Rack::Server] server
      #   The Rack Handler server.
      #
      # @param [#stop!, #stop] handler
      #   The Rack Handler.
      #
      # @api private
      #
      def quit!(server,handler)
        host = server.options[:Host]
        port = server.options[:Port]

        # Use thins' hard #stop! if available, otherwise just #stop
        handler.respond_to?(:stop!) ? handler.stop! : handler.stop

        print_info "Stopping Web Proxy on #{host}:#{port}"
      end

      #
      # @see #call!
      #
      # @api semipublic
      #
      def call(env)
        dup.call!(env)
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
      # @api private
      #
      def call!(env)
        request = Request.new(env)

        @on_request_block.call(request) if @on_request_block

        print_debug "Proxying #{request.url} for #{request.address}"
        request.headers.each do |name,value|
          print_debug "  #{name}: #{value}"
        end

        response = proxy(request)

        if @on_response_block
          case @on_response_block.arity
          when 1 then @on_response_block.call(response)
          else        @on_response_block.call(request,response)
          end
        end

        print_debug "Returning proxied response for #{request.address}"
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
      # @api private
      #
      def proxy(request)
        options = {
          ssl:          (request.scheme == 'https'),
          host:         request.host,
          port:         request.port,
          method:       request.request_method,
          path:         request.path_info,
          query:        request.query_string,
          content_type: request.content_type,
          headers:      request.headers
        }

        if request.form_data?
          options[:form_data] = request.POST
        end

        http_response = http_request(options)
        http_headers = {}

        http_response.each_capitalized do |name,value|
          unless HEADERS_BLACKLIST.include?(name)
            http_headers[name] = value
          end
        end

        return Response.new(
          (http_response.body || ''),
          http_response.code,
          http_headers
        )
      end

    end
  end
end
