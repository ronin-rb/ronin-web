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

require 'ronin/web/server/request'

module Ronin
  module Web
    class Proxy
      #
      # Convenience class that represents proxied requests.
      #
      class Request < Server::Request

        #
        # Changes the HTTP Host header of the request.
        #
        # @param [String] new_host
        #   The new value of the HTTP Host header.
        #
        # @return [String]
        #   The new HTTP Host header.
        #
        # @since 0.3.0
        #
        # @api public
        #
        def host=(new_host)
          @env['HTTP_HOST'] = new_host
        end

        #
        # Changes the port the request is being sent to.
        #
        # @param [Integer] new_port
        #   The new port the request will be sent to.
        #
        # @return [Integer]
        #   The new port the request will be sent to.
        #
        # @since 0.3.0
        #   
        # @api public
        #
        def port=(new_port)
          @env['SERVER_PORT'] = new_port
        end

        #
        # Changes the URI scheme of the request.
        #
        # @param [String] new_port
        #   The new URI scheme for the request.
        #
        # @return [String]
        #   The new URI scheme of the request.
        #
        # @since 0.3.0
        #   
        # @api public
        #
        def scheme=(new_scheme)
          @env['rack.url_scheme'] = new_scheme
        end

        #
        # Causes the request to be proxied over SSL.
        #
        # @return [ProxyRequest]
        #   The proxy request.
        #
        # @since 0.3.0
        #
        # @api public
        #
        def ssl!
          self.port = 443
          self.scheme = 'https'

          return self
        end

        #
        # Changes the HTTP Request Method of the request.
        #
        # @param [String] new_method
        #   The new HTTP Request Method.
        #
        # @return [String]
        #   The new HTTP Request Method.
        #
        # @since 0.3.0
        #
        # @api public
        #
        def request_method=(new_method)
          @env['REQUEST_METHOD'] = new_method
        end

        #
        # Changes the HTTP Query String of the request.
        #
        # @param [String] new_query
        #   The new HTTP Query String for the request.
        #
        # @return [String]
        #   The new HTTP Query String of the request.
        #
        # @since 0.3.0
        #
        # @api public
        #
        def query_string=(new_query)
          @env['QUERY_STRING'] = new_query
        end

        #
        # Specifies that the request is a XML HTTP Request.
        #
        # @yield [request]
        #   If a block is given, it will be passed the request
        #   for further modification.
        #
        # @yieldparam [ProxyRequest] request
        #   The proxy request.
        #
        # @return [ProxyRequest]
        #   The request.
        #
        # @since 0.3.0
        #
        # @api public
        #
        def xhr!
          @env['HTTP_X_REQUESTED_WITH'] = 'XMLHttpRequest'

          yield self if block_given?
          return self
        end

        #
        # Changes the HTTP Content-Type header of the request.
        #
        # @param [String] new_content_type
        #   The new HTTP Content-Type for the request.
        #
        # @return [String]
        #   The new HTTP Content-Type of the request.
        #
        # @since 0.3.0
        #
        # @api public
        #
        def content_type=(new_content_type)
          @env['CONTENT_TYPE'] = new_content_type
        end

        #
        # Changes the HTTP Accept-Encoding header of the request.
        #
        # @param [String] new_encoding
        #   The new HTTP Accept-Encoding for the request.
        #
        # @return [String]
        #   The new HTTP Accept-Encoding of the request.
        #
        # @since 0.3.0
        #
        # @api public
        #
        def accept_encoding=(new_encoding)
          @env['HTTP_ACCEPT_ENCODING'] = new_encoding
        end

        #
        # Sets the HTTP User-Agent header of the request.
        #
        # @param [String] new_user_agent
        #   The new User-Agent header to use.
        #
        # @return [String]
        #   The new User-Agent header.
        #
        # @since 0.3.0
        #
        # @api public
        #
        def user_agent=(new_user_agent)
          @env['HTTP_USER_AGENT'] = new_user_agent
        end

        #
        # Changes the HTTP Referer header of the request.
        #
        # @param [String] new_referer
        #   The new HTTP Referer for the request.
        #
        # @return [String]
        #   The new HTTP Referer of the request.
        #
        # @since 0.3.0
        #
        # @api public
        #
        def referer=(new_referer)
          @env['HTTP_REFERER'] = new_referer
        end

        alias referrer= referer=

        #
        # Changes the body of the request.
        #
        # @param [String] new_body
        #   The new body for the request.
        #
        # @return [String]
        #   The new body of the request.
        #
        # @since 0.3.0
        #
        # @api public
        #
        def body=(new_body)
          @env['rack.input'] = new_body
        end

      end
    end
  end
end
