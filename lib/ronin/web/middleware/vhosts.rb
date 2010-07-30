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
      #
      # A Rack middleware for routing requests to other applications based
      # on the HTTP Host header.
      #
      #     use Ronin::Web::Middleware::VHosts do |vhosts| do
      #       vhosts.map 'cdn.example.com', CDNApp
      #       vhosts.map /ssl\./, FakeSSLApp
      #     end
      #
      class VHosts < Base

        #
        # Creates a new vhosts middleware.
        #
        # @param [#call] app
        #   The application that the middleware will sit in front of.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Hash{String, Regexp => #call}] :vhosts
        #   The virutal-host names and applications to route.
        #
        # @yield [vhosts]
        #   If a block is given, it will be passed the vhosts middlware.
        #
        # @yieldparam [VHosts] vhosts
        #   The newly created vhosts middleware object.
        #
        # @since 0.2.2
        #
        def initialize(app,options={})
          @vhosts = {}

          if options[:vhosts]
            options[:vhosts].each { |vhost,app| map(vhost,app) }
          end

          super(app,options,&block)
        end

        #
        # Maps a virtual-host to another app.
        #
        # @param [String, Regexp] vhost
        #   The virtual-host name or pattern to match.
        #
        # @param [#call] sub_app
        #   The application that will receive requests for the virtual-host.
        #
        # @yield [request]
        #   The given block will receive requests for the virtual-host.
        #
        # @yieldparam [Rack::Request] request
        #   An incoming request.
        #
        # @return [VHosts]
        #   The vhosts middleware.
        #
        # @example
        #   vhosts.map 'secret.example.com', SecretApp
        #
        # @example
        #   vhosts.map 'secret.example.com' do |request|
        #     response ['Nothing here'], 404
        #   end
        #
        # @since 0.2.2
        #
        def map(vhost,sub_app=nil,&block)
          @vhosts[vhost] = (sub_app || block)
          return self
        end

        #
        # Routes a request to an another application based on the
        # virtual-host.
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
          if (host = env['HTTP_HOST'])
            @vhosts.each do |vhost,sub_app|
              match = if vhost.kind_of?(Regexp)
                        host =~ vhost
                      else
                        host == vhost
                      end

              return sub_app.call(env) if match
            end
          end

          super(env)
        end

      end
    end
  end
end
