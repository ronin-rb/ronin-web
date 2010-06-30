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

module Ronin
  module Web
    module Middleware
      #
      # A Rack middleware to host local files at specific remote paths.
      #
      #     use Ronin::Web::Middleware::Files do |files|
      #       files.map '/foo.txt', 'foo.txt'
      #       files.map /\.exe$/, 'trojan.exe'
      #     end
      #
      class Files < Base

        # The mapping of remote paths to local paths
        attr_reader :files

        #
        # Creates a new {Files} middleware.
        #
        # @param [#call] app
        #   The application the middleware sits in front of.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Integer] :status (200)
        #   The status code to return.
        #
        # @option options [Hash] :headers
        #   The headers to return.
        #
        # @option options [Hash] :files
        #   The mapping of remote paths to local paths.
        #
        # @yield [files]
        #   If a block is given, it will be passed the new files middleware.
        #
        # @yieldparam [Files] files
        #   The new files middleware object.
        #
        # @since 0.2.2
        #
        def initialize(app,options={},&block)
          @files = {}
          @files.merge!(options[:files]) if options.has_key?(:files)

          super(app,&block)
        end

        #
        # Maps the local path to a remote path.
        #
        # @param [Regexp, String] remote_path
        #   The remote path to expose.
        #
        # @param [String] local_path
        #   The local path to host.
        #
        # @return [true]
        #
        # @example Mapping a path
        #   map '/foo.txt', 'foo.txt'
        #
        # @example Mapping multiple paths using a regular expression
        #   map /\.exe$/, 'trojan.exe'
        #
        # @since 0.2.2
        #
        def map(remote_path,local_path)
          @files[remote_path] = local_path
          return true
        end

        #
        # Returns a local file if it was mapped to a remote path.
        #
        # @param [Hash, Rack::Request] env
        #   The request.
        #
        # @return [Array, Rack::Response]
        #   The response.
        #
        # @since 0.2.2
        #
        def call(env)
          path = File.expand_path(unescape(env['PATH_INFO']))

          @files.each do |pattern,local_path|
            matched = if patterh.kind_of?(Regexp)
                        path =~ pattern
                      else
                        path == pattern
                      end

            return response_for(local_path) if matched
          end

          super(env)
        end

      end
    end
  end
end
