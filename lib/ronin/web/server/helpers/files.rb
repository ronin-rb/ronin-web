#
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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

module Ronin
  module Web
    module Server
      module Helpers
        module Files
          # Directory index files
          INDICES = ['index.htm', 'index.html']

          #
          # Sets the content_type based on the extension of a given file.
          #
          # @param [String] path
          #   The path to guess the content-type for.
          #
          # @return [String]
          #   The MIME content-type of the file.
          #
          # @example
          #   content_type_for 'file.html'
          #
          # @since 0.2.0
          #
          def content_type_for(path)
            ext = File.extname(path).downcase

            return content_type(ext[1..-1])
          end

          #
          # Finds the index file for a given directory.
          #
          # @param [String] path
          #   The path of the directory.
          #
          # @yield [index_path]
          #   If a block is given, it will be passed the path of the
          #   index file for the given directory.
          # 
          # @yieldparam [String] index_path
          #   The path to the index file.
          #
          # @return [String]
          #   The path to the index file.
          #
          def index_of(path,&block)
            path = File.expand_path(path)

            Base.indices.each do |name|
              index = File.join(path,name)

              if File.file?(index)
                block.call(index) if block
                return index
              end
            end

            pass
          end

          #
          # Returns a file to the client with the appropriate content-type.
          #
          # @param [String] path
          #   The path of the file to return.
          #
          # @param [Symbol] custom_content_type
          #   Optional content-type to return the file with.
          #
          # @example
          #   return_file 'lol.jpg'
          #
          # @example
          #   return_file '/tmp/file', :html
          #
          def return_file(path,custom_content_type=nil)
            path = File.expand_path(path)

            pass unless File.exists?(path)

            if File.directory?(path)
              index_of(path) { |index| path = index }
            end

            if custom_content_type
              content_type custom_content_type
            else
              content_type_for path
            end

            case request.request_method
            when 'GET', 'POST'
              halt 200, File.new(path)
            else
              halt 302
            end
          end
        end
      end
    end
  end
end
