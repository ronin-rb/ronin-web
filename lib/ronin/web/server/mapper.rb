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
      module Mapper
        def self.included(base)
          base.module_eval do
            #
            # Maps all requests to the specified _http_path_ to the
            # specified _server_.
            #
            #   MyApp.map '/subapp/', SubApp
            #
            def self.map(http_path,server)
              http_path = File.join(http_path,'')

              before do
                if http_path == request.path_info[0..http_path.length]
                  server.call(request)
                end
              end
            end
          end
        end
      end
    end
  end
end
