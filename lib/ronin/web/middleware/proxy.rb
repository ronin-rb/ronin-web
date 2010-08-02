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
require 'ronin/web/middleware/request'

require 'ronin/network/http'

module Ronin
  module Web
    module Middleware
      class Proxy < Base

        # The host to proxy
        attr_accessor :host

        # The port(s) to proxy
        attr_accessor :port

        # The HTTP request method to proxy for
        attr_accessor :request_method

        # The request path to proxy for
        attr_accessor :request_path

        # The request query string to proxy for
        attr_accessor :request_query

        # The HTTP response Status Code(s) to proxy for
        attr_accessor :response_status

        # The response body pattern to proxy for
        attr_accessor :response_body

        #
        # Creates a new {Proxy} middleware.
        #
        # @param [#call] app
        #   The application that the proxy middleware sits in front of.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [String, Regexp] :host
        #   The host to proxy.
        #
        # @option options [Integer, Range] :port
        #   The port(s) to proxy.
        #
        # @option options [String] :request_method
        #   The HTTP request method to proxy for.
        #
        # @option options [String, Regexp] :request_path
        #   The request paths to proxy for.
        #
        # @option options [String, Regexp] :request_query
        #   The request query strings to proxy for.
        #
        # @option options [Integer, Range] :response_status
        #   The HTTP response Status Code(s) to proxy for.
        #
        # @option options [String, Regexp] :response_body
        #   The response body patterns to proxy for.
        #
        # @option options [Proc] :requests_like
        #   A proc that will determine whether or not to proxy a request.
        #
        # @option options [Proc] :responses_like
        #   A proc that will determine whether or not to proxy a response.
        #
        # @yield [proxy]
        #   If a block is given, it will be passed the new proxy middleware.
        #
        # @yieldparam [Proxy] proxy
        #   The new proxy middleware object.
        #
        # @since 0.2.2
        #
        def initialize(app,options={},&block)
          @host = options[:host]
          @port = options[:port]

          @request_method = options[:request_method]
          @request_path = options[:request_path]
          @request_query = options[:request_query]

          @response_status = options[:response_status]
          @response_body = options[:response_body]

          @requests_like_block = options[:requests_like]
          @responses_like_block = options[:responses_like]

          super(app,options,&block)
        end

        #
        # Uses a given block to determine whether or not to manipulate
        # requests.
        #
        # @yield [request]
        #   The given block will be passed each request.
        #
        # @yieldparam [Request] request
        #   A request received by the middleware.
        #
        # @return [Proxy]
        #   The proxy middleware.
        #
        # @since 0.2.2
        #
        def requests_like(&block)
          @requests_like_block = block
          return self
        end

        #
        # Uses a given block to determine whether or not to manipulate
        # responses.
        #
        # @yield [response]
        #   The given block will be passed every proxied response.
        #
        # @yieldparam [Rack::Response] response
        #   A response returned from a proxied request.
        #
        # @return [Proxy]
        #   The proxy middleware.
        #
        # @since 0.2.2
        #
        def responses_like(&block)
          @responses_like_block = block
          return self
        end

        #
        # Uses the given block to manipulate incoming requests.
        #
        # @yield [request]
        #   The given block will receive every incoming request, before it
        #   is proxied.
        #
        # @yieldparam [Request] request
        #   A proxied request.
        #
        # @return [Proxy]
        #   The proxy middleware.
        #
        # @since 0.2.2
        #
        def proxy_requests(&block)
          @proxy_requests_block = block
          return self
        end

        #
        # Uses the given block to manipulate proxied responses.
        #
        # @yield [response]
        #   The given block will receive every proxied response.
        #
        # @yieldparam [Rack::Response] response
        #   A proxied response.
        #
        # @return [Proxy]
        #   The proxy middleware.
        #
        # @since 0.2.2
        #
        def proxy_responses(&block)
          @proxy_responses_block = block
          return self
        end

        #
        # Proxies a request.
        #
        # @param [Request] request
        #   The request to send.
        #
        # @return [Rack::Response]
        #   The response from the request.
        #
        def proxy(request)
          options = {
            :host => request.host,
            :port => request.port,
            :method => request.request_method,
            :path => request.path_info,
            :query => request.query_string,
            :content_type => request.content_type
          }

          if request.form_data?
            options[:form_data] = request.POST
          end

          request.env.each do |name,value|
            if name =~ /^HTTP_/
              options[name.sub('HTTP_','').downcase.to_sym] = value
            end
          end

          http_response = Net.http_request(options)

          return Rack::Response.new(
            [http_response.body],
            http_response.code,
            http_response.to_hash
          )
        end

        #
        # Receives incoming requests, proxies them, allowing manipulation
        # of the requests and their responses.
        #
        # @param [Hash, Rack::Request] env
        #   The request.
        #
        # @return [Rack::Response]
        #   The response.
        #
        # @since 0.2.2
        #
        def call(env)
          request = Request.new(env)
          matched = true

          if @host
            matched &&= if @host.kind_of?(Regexp)
                        request.host =~ @host
                      else
                        request.host == @host
                      end
          end

          if @port
            matched &&= if @port.kind_of?(Range)
                        @port.include?(request.port)
                      else
                        request.port == @port
                      end
          end

          if @request_method
            matched &&= (request.request_method == @request_method)
          end

          if @request_path
            matched &&= if @request_path.kind_of?(Regexp)
                        request.path =~ @request_path
                      else
                        request.path[0,@request_path.length] == @request_path
                      end
          end

          if @request_query
            matched &&= if @request_query.kind_of?(Regexp)
                        request.query_string =~ @request_query
                      else
                        request.query_string == @request_query
                      end
          end

          if @requests_like_block
            matched &&= @requests_like_block.call(request)
          end

          if matched
            if @proxy_requests_block
              request = (@proxy_requests_block.call(request) || request)
            end
          else
            return super(env)
          end

          response = proxy(request)
          matched = true

          if @response_status
            matched &&= if @response_status.kind_of?(Range)
                          @response_status.include?(response.status)
                        else
                          response.status == @response_status
                        end
          end

          if @response_body
            matched &&= response.body.any? { |chunk| chunk.match(@response_body) }
          end

          if @responses_like_block
            matched &&= @responses_like_block.call(response)
          end

          if (@proxy_responses_block && matched)
            response = (@proxy_responses_block.call(response) || response)
          end

          return response
        end

      end
    end
  end
end
