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
            # Routes requests with a specific Host header to another
            # web server.
            #
            # @param [String] name
            #   The host-name to route requests for.
            #
            # @param [Base, #call] server
            #   The web server to route the requests to.
            #
            # @example
            #   MyApp.host 'cdn.evil.com', EvilServer
            #
            # @since 0.2.0
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
            # Routes requests with a matching Host header to another web
            # server.
            #
            # @param [Regexp, String] pattern
            #   The pattern to match Host headers of requests.
            #
            # @param [Base, #call] server
            #   The server to route the requests to.
            #
            # @example
            #   MyApp.hosts_like /^a[0-9]\./, FileProxy
            #
            # @since 0.2.0
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
