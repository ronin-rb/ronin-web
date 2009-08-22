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
          # Sets the content_type based on the extension of the specified
          # _path_.
          #
          # @example
          #   content_type_for 'file.html'
          #
          def content_type_for(path)
            ext = File.extname(path).downcase

            return content_type(ext[1..-1])
          end

          #
          # Passes the path to the index file within the specified _path_
          # to the given _block_.
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
          # Sets the content_type using the extension of the specified
          # _path_ and returns a File object.
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
