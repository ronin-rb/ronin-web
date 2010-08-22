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

require 'ronin/web/middleware/helpers'

module Ronin
  module Web
    module Middleware
      class Base

        include Helpers

        # The default status code to return
        DEFAULT_STATUS = 200

        # The status code to return
        attr_accessor :default_status

        # The default headers to return
        attr_reader :default_headers

        #
        # Creates a new middleware object.
        #
        # @param [#call] app
        #   The application the middleware will sit in front of.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Integer] :default_status (DEFAULT_STATUS)
        #   The status code to return.
        #
        # @option options [Hash] :default_headers
        #   The headers to return.
        #
        # @yield [middleware]
        #   If a block is given, it will be passed the new middleware.
        #
        # @yieldparam [Base] middleware
        #   The new middleware object.
        #
        # @since 0.3.0
        #
        def initialize(app,options={})
          @app = app

          @default_status = (options[:default_status] || DEFAULT_STATUS)
          @default_headers = {}

          if options.has_key?(:default_headers)
            @default_headers.merge!(options[:default_headers])
          end

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
        # @since 0.3.0
        #
        def call(env)
          @app.call(env)
        end

        protected

        #
        # Creates a new response.
        #
        # @param [String, Array, IO] body
        #   The body for the response.
        #
        # @param [Hash] headers
        #   Additional headers for the response.
        #
        # @param [Integer] status
        #   The HTTP Status Code for the response.
        #
        # @yield [response]
        #   If a block is given, it will be passed the new response.
        #
        # @yieldparam [Response] response
        #   The new response.
        #
        # @return [Array]
        #   The new response.
        #
        # @example Create a response.
        #   response ['Hello'], {'Content-Type' => 'text/txt'}, 200
        #
        # @example Create a response with just a String.
        #   response 'Hello'
        #
        # @since 0.3.0
        #
        def response(body=[],headers={},status=nil)
          status ||= @default_status
          headers = @default_headers.merge(headers)

          return super(body,headers,status)
        end

      end
    end
  end
end
