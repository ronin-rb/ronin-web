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

require 'ronin/web/server/helpers/hosts'

module Ronin
  module Web
    module Server
      module Hosts
        def self.included(base)
          base.module_eval do
            #
            # Registers the specified _server_ to be called when receiving
            # requests for the specified host _name_.
            #
            #   MyApp.host 'cdn.evil.com', EvilServer
            #
            def self.host(name,server)
              name = name.to_s

              before do
                if request.host == name
                  halt(*server.call(request.env))
                end
              end
            end

            #
            # Registers the given _server_ to be called when receiving
            # requests to host names which match the specified _pattern_.
            #
            #   MyApp.hosts_like /^a[0-9]\./, FileProxy
            #
            def self.hosts_like(pattern,server)
              before do
                if request.host.match(pattern)
                  halt(*server.call(request.env))
                end
              end
            end

            protected

            helpers Ronin::Web::Server::Helpers::Hosts
          end
        end
      end
    end
  end
end
