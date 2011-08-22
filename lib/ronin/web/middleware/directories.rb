#
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/web/middleware/base'

require 'set'

module Ronin
  module Web
    module Middleware
      #
      # A Rack middleware to host local directories at specific remote
      # paths.
      #
      #     use Ronin::Web::Middleware::Directories do |dirs|
      #       dirs.map '/downloads', '/tmp/ronin_downloads'
      #     end
      #
      class Directories < Base

        # The predefined index file names
        INDEX_NAMES = %w[index.html index.xhtml index.htm]

        # The mapping of remote paths to local directories 
        attr_reader :paths

        #
        # Creates a new {Directories} middleware.
        #
        # @param [#call] app
        #   The application the middleware sits in front of.
        #
        # @param [Hash{String,Regexp => String}] paths
        #   The mapping of remote paths to local directories.
        #
        # @yield [directories]
        #   If a block is given, it will be passed the new directories
        #   middleware.
        #
        # @yieldparam [Directories] directories
        #   The new directories middleware object.
        #
        # @since 0.3.0
        #
        # @api public
        #
        def initialize(app,paths={},&block)
          @paths = {}
          @paths_order = []

          paths.each do |remote_path,local_dir|
            map(remote_path,local_dir)
          end

          super(app,&block)
        end

        #
        # The names of index files.
        #
        # @return [Set]
        #   The set of index file names.
        #
        # @since 0.3.0
        #
        # @api public
        #
        def Directories.index_names
          @@directories_index_names ||= Set.new(INDEX_NAMES)
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
        # @since 0.3.0
        #
        # @api public
        #
        def map(remote_path,local_dir)
          @paths[remote_path] = local_dir
          
          # sort paths by number of sub-directories
          @paths_order = @paths.keys.sort_by do |path|
            -(path.split('/').length)
          end

          return true
        end

        #
        # Returns a file from a local directory, if the directory
        # was mapped to a remote path.
        #
        # @param [Hash, Rack::Request] env
        #   The request.
        #
        # @return [Array, Response]
        #   The response.
        #
        # @since 0.3.0
        #
        # @api public
        #
        def call(env)
          path = sanitize_path(env['PATH_INFO'])

          p @paths_order

          # finds the remote directory that the paths starts with or is
          # equal to.
          remote_path = @paths_order.find do |remote_path|
                          if remote_path == '/'
                            true
                          elsif path.start_with?(remote_path)
                            (path[remote_path.length,1] == '/') ||
                            (path.length == remote_path.length)
                          end
                        end

          if remote_path
            local_dir = @paths[remote_path]
            sub_path = path[remote_path.length..-1]

            return_file = proc { |local_path|
              if File.file?(local_path)
                request = Request.new(env)

                print_info "Returning file #{local_path.dump} for #{request.address}"
                return response_for(local_path)
              end
            }

            if sub_path.empty?
              # attempt to find an index file in the directory
              Directories.index_names.each do |index|
                return_file.call(File.join(local_dir,index))
              end
            else
              return_file.call(File.join(local_dir,sub_path))
            end
          end

          super(env)
        end

      end
    end
  end
end
