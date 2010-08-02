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

require 'rack/request'

module Ronin
  module Web
    module Middleware
      class ProxyRequest < Rack::Request

        #
        # Changes the HTTP Host header of the request.
        #
        # @param [String] new_host
        #   The new value of the HTTP Host header.
        #
        # @return [String]
        #   The new HTTP Host header.
        #
        # @since 0.2.2
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
        # @since 0.2.2
        #   
        def port=(new_port)
          @env['SERVER_PORT'] = new_port
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
        # @since 0.2.2
        #
        def request_method=(new_method)
          @env['REQUEST_METHOD'] = new_method
        end

        #
        # Changes the HTTP Path the request is being sent to.
        #
        # @param [String] new_path
        #   The new HTTP Path the request will be sent to.
        #
        # @return [String]
        #   The new HTTP Path the request will be sent to.
        #
        # @since 0.2.2
        #
        def path=(new_path)
          @env['PATH_INFO'] = new_path
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
        # @since 0.2.2
        #
        def query_string=(new_query)
          @env['QUERY_STRING'] = new_query
        end

        #
        # Specifies that the request is a XML HTTP Request.
        #
        # @return [ProxyRequest]
        #   The request.
        #
        # @since 0.2.2
        #
        def xhr!
          @env['HTTP_X_REQUESTED_WITH'] = 'XMLHttpRequest'
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
        # @since 0.2.2
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
        # @since 0.2.2
        #
        def accept_encoding=(new_encoding)
          @env['HTTP_ACCEPT_ENCODING'] = new_encoding
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
        # @since 0.2.2
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
        # @since 0.2.2
        #
        def body=(new_body)
          @env['rack.input'] = new_body
        end

      end
    end
  end
end
