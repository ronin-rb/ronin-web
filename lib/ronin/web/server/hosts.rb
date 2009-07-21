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

require 'ronin/web/server/helpers/hosts'

module Ronin
  module Web
    module Server
      module Hosts
        def self.included(base)
          base.module_eval do
            @@vhost_patterns = {}
            @@vhosts = {}

            @@vhost_patterns_mutex = Mutex.new
            @@vhosts_mutex = Mutex.new

            #
            # Registers the given _server_ to be called when receiving
            # requests to host names which match the specified _pattern_.
            #
            #   Server.hosts_like(/^a[0-9]\./, FileProxy)
            #
            def self.hosts_like(pattern,server)
              @@vhost_patterns_mutex.synchronize do
                @@vhost_patterns[pattern] = server
              end
            end

            #
            # Registers the specified _server_ to be called when receiving
            # requests with the specified host _name_.
            #
            #   Server.host('cdn.evil.com', EvilServer)
            #
            def self.host(name,server)
              @@vhosts_mutex.synchronize do
                @@vhosts[name.to_s] = server
              end
            end

            #
            # Returns the server that handles requests for the specified host
            # _name_.
            #
            def host_for(name)
              name = name.to_s

              @@vhosts_mutex.synchronize do
                if @@vhosts.has_key?(name)
                  return @@vhosts[name]
                end
              end

              @@vhost_patterns_mutex.synchronize do
                @@vhost_patterns.each do |pattern,server|
                  return server if name.match(pattern)
                end
              end

              return nil
            end

            #
            # The method which receives all requests.
            #
            def self.call(env)
              http_host = env['HTTP_HOST']

              if http_host
                if (server = self.host_for(http_host))
                  return server.call(env)
                end
              end

              return super(env)
            end

            protected

            helpers Ronin::Web::Server::Helpers::Hosts
          end
        end
      end
    end
  end
end
