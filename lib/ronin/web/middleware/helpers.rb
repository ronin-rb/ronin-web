#
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/web/middleware/request'
require 'ronin/web/middleware/response'

require 'rack'

module Ronin
  module Web
    module Middleware
      #
      # A module containing helper methods that can be used in Rack
      # Middleware and Rack Apps.
      #
      module Helpers
        include Rack::Utils

        alias h escape_html

        #
        # Sanitizes a path received by the middleware.
        #
        # @param [String] path
        #   The unsanitized path.
        #
        # @return [String]
        #   The unescaped and absolute path.
        #
        # @since 0.3.0
        #
        # @api semipublic
        #
        def sanitize_path(path)
          File.expand_path(unescape(path))
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
        # @since 0.3.0
        #
        # @api semipublic
        #
        def mime_type_for(path)
          Rack::Mime.mime_type(File.extname(path))
        end

        alias content_type_for mime_type_for

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
        # @api semipublic
        #
        def response(body=[],headers={},status=200)
          response = Response.new(body,status,headers)

          yield(response) if block_given?
          return response
        end

        #
        # Creates a new response for a file.
        #
        # @param [String] path
        #   The path to the file.
        #
        # @param [Hash] headers
        #   Additional headers for the response.
        #
        # @param [Integer] status
        #   The HTTP Status Code for the response.
        #
        # @return [Response]
        #   The new response object.
        #
        # @see #response
        #
        # @since 0.3.0
        #
        # @api semipublic
        #
        def response_for(path,headers={},status=200)
          response(
            File.new(path),
            headers.merge('Content-Type' => mime_type_for(path)),
            status
          )
        end
      end
    end
  end
end
