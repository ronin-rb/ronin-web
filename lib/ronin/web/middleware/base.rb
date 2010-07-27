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

require 'rack'

module Ronin
  module Web
    module Middleware
      class Base

        # The default status code to return
        DEFAULT_STATUS = 200

        # The status code to return
        attr_accessor :status

        # The default headers to return
        attr_reader :headers

        #
        # Creates a new middleware object.
        #
        # @param [#call] app
        #   The application the middleware will sit in front of.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Integer] :status (DEFAULT_STATUS)
        #   The status code to return.
        #
        # @option options [Hash] :headers
        #   The headers to return.
        #
        # @yield [middleware]
        #   If a block is given, it will be passed the new middleware.
        #
        # @yieldparam [Base] middleware
        #   The new middleware object.
        #
        # @since 0.2.2
        #
        def initialize(app,options={})
          @app = app

          @status = (options[:status] || DEFAULT_STATUS)
          @headers = {}

          @headers.merge!(options[:headers]) if options.has_key?(:headers)

          yield self if block_given?
        end

        #
        # Passes the request to the application.
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
          @app.call(env)
        end

        protected

        #
        # Unescapes the given data.
        #
        # @param [String] data
        #   The given data.
        #
        # @return [String]
        #   The unescaped data.
        #
        # @since 0.2.2
        #
        def unescape(data)
          Rack::Utils.unescape(data)
        end

        #
        # Returns the MIME type for a path.
        #
        # @param [String] path
        #   The path to determine the MIME type for.
        #
        # @return [String]
        #   The MIME type for the path.
        #
        # @since 0.2.2
        #
        def mime_type_for(path)
          Rack::Mime.mime_type(File.extname(path))
        end

        #
        # Creates a new response.
        #
        # @param [Array, IO] body
        #   The body for the response.
        #
        # @param [Integer] status
        #   The HTTP Status Code for the response.
        #
        # @param [Hash] headers
        #   Additional headers for the response.
        #
        # @yield [response]
        #   If a block is given, it will be passed the new response.
        #
        # @yieldparam [Rack::Response] response
        #   The new response object.
        #
        # @return [Rack::Response]
        #   The new response object.
        #
        # @since 0.2.2
        #
        def response(body=[],status=nil,headers={},&block)
          Rack::Response.new(body,(status || @status),@headers.merge(headers),&block)
        end

        #
        # Creates a new response for a file.
        #
        # @param [String] path
        #   The path to the file.
        #
        # @param [Integer] status
        #   The HTTP Status Code for the response.
        #
        # @param [Hash] headers
        #   Additional headers for the response.
        #
        # @return [Rack::Response]
        #   The new response object.
        #
        # @see #response
        #
        # @since 0.2.2
        #
        def response_for(path,status=nil,headers={})
          response(File.new(path),status,headers.merge('Content-Type' => mime_type_for(path)))
        end

      end
    end
  end
end
