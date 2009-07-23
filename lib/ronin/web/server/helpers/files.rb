#
#--
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
#++
#

module Ronin
  module Web
    module Server
      module Helpers
        module Files
          # Directory index files
          INDICES = ['index.htm', 'index.html']

          #
          # Sets the content_type based on the extension of the specified _path_.
          #
          #   content_type_for 'file.html'
          #
          def content_type_for(path)
            ext = File.extname(path).downcase

            return content_type(ext[1..-1])
          end

          #
          # Sets the content_type using the extension of the specified _path_
          # and returns a File object.
          #
          #   return_file 'lol.jpg'
          #
          def return_file(path)
            path = File.expand_path(path)

            unless File.file?(path)
              return pass
            end

            content_type_for path

            case request.request_method
            when 'GET', 'POST'
              halt 200, File.new(path)
            else
              halt 302
            end
          end

          #
          # Returns the index file contained within the _path_ of the specified
          # directory. If no index file can be found, +nil+ will be returned.
          #
          def index_of(path)
            path = File.expand_path(path)

            INDICES.each do |name|
              index = File.join(path,name)

              return index if File.file?(index)
            end

            return nil
          end
        end
      end
    end
  end
end
