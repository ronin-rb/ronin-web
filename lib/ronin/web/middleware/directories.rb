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
      class Directories < Base

        # The mapping of remote paths to local directories 
        attr_reader :directories

        #
        # Creates a new {Directoies} middleware.
        #
        # @param [#call] app
        #   The application the middleware sits in front of.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Hash{String => String}] :paths
        #   The mapping of remote paths to local directories.
        #
        # @yield [directories]
        #   If a block is given, it will be passed the new directories middleware.
        #
        # @yieldparam [Directories] directories
        #   The new directories middleware object.
        #
        # @since 0.2.2
        #
        def initialize(app,options={},&block)
          @directories = {}

          if options.has_key?(:paths)
            @directories.merge!(options[:paths])
          end

          super(app,&block)
        end

        #
        # Maps a remote path to a local directory.
        #
        # @param [String] remote_path
        #   The remote path to map.
        #
        # @param [String] local_dir
        #   The local directory that the remote path will map to.
        #
        # @return [true]
        #
        # @since 0.2.2
        #
        def map(remote_path,local_dir)
          @directories[remote_path + '/'] = local_dir
          return true
        end

        #
        # Returns a file from a local directory, if the directory
        # was mapped to a remote path.
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
          path = sanitize_path(env['PATH_INFO'])

          @directories.each do |remote_path,local_path|
            if path[0,remote_path.length] == remote_path
              sub_path = path[remote_path.length..-1]

              return response_for(File.join(local_path,sub_path))
            end
          end

          super(env)
        end

      end
    end
  end
end
