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

        #
        # Creates a new middleware object.
        #
        # @param [#call] app
        #   The application the middleware will sit in front of.
        #
        # @yield [middleware]
        #   If a block is given, it will be passed the new middleware.
        #
        # @yieldparam [Base] middleware
        #   The new middleware object.
        #
        # @since 0.2.2
        #
        def initialize(app)
          @app = app

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

      end
    end
  end
end
