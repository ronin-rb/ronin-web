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

require 'ronin/web/server/helpers/files'

module Ronin
  module Web
    module Server
      module Files
        def self.included(base)
          base.module_eval do
            #
            # Hosts the contents of the specified _path_ at the specified
            # _http_path_.
            #
            #   MyApp.file '/robots.txt', '/path/to/my_robots.txt'
            #
            def self.file(http_path,path)
              any(http_path) do
                return_file(request.path_info)
              end
            end

            #
            # Hosts the contents of the specified _directory_ at the specified
            # _http_path_.
            #
            #   MyApp.directory '/download/', '/tmp/files/'
            #
            def self.directory(http_path,directory)
              any(File.join(http_path,'*')) do
                return_file(File.join(directory,File.expand_path(File.join('/',params[:splat]))))
              end
            end

            protected

            helpers Ronin::Web::Server::Helpers::Files
          end
        end
      end
    end
  end
end
