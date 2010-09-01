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

require 'ronin/web/middleware/rule'
require 'ronin/web/middleware/base'

module Ronin
  module Web
    module Middleware
      #
      # A Rack middleware for routing requests based on predefined rules.
      #
      #     use Ronin::Web::Middleware::Router do |router|
      #       # route requests by source IP address
      #       router.draw :ip => '212.18.45.0/24', :to => BannedApp
      #       router.draw :ip => '192.168.0.0/16' do |request|
      #         response ['Nothing here'], 404
      #       end
      #
      #       # route requests by Referer URL
      #       router.draw :referer => 'http://www.sexy.com/', :to => TrapApp
      #       router.draw :referer => /\.google\./ do |request|
      #         response ['Nothing to see here.'], 404
      #       end
      #
      #       # route requests by User-Agent
      #       router.draw :user_agent => /Microsoft/, :to => IEApp
      #
      #       # mix route options together
      #       router.draw :ip => '212.18.45.0/24',
      #                   :user_agent => /Microsoft/, :to => PwnApp
      #     end
      #
      class Router < Base

        # The routes of the router
        attr_reader :routes

        #
        # Creates a new Router middleware.
        #
        # @param [#call] app
        #   The application that the router sits in front of.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @yield [router]
        #   If a block is given, it will be passed the newly created
        #   router middleware.
        #
        # @yieldparam [Router] router
        #   The new router middleware object.
        #
        # @since 0.3.0
        #
        def initialize(app,options={},&block)
          @routes = {}

          super(app,options,&block)
        end

        #
        # Defines a rule to route requests by.
        #
        # @param [Hash] options
        #   Filter options.
        #
        # @option options [String] :campaign
        #   The name of the campaign who's targetted hosts will be routed.
        #
        # @option options [String, Regexp] :vhost
        #   The Virtual-Host to route.
        #
        # @option options [String, IPAddr] :ip
        #   The IP address or IP range to route.
        #
        # @option options [String, Regexp] :referer
        #   The Referer URL or pattern to route.
        #
        # @option options [String, Regexp] :user_agent
        #   The User-Agent string to route.
        #
        # @option options [Proc] :when
        #   Custom logic to route requests by.
        #
        # @option options [#call] :to
        #   The application that will receive routed requests.
        #
        # @yield [request]
        #   If a block is given, it will receive routed requests.
        #
        # @yieldparam [Rack::Request] request
        #   A routed request.
        #
        # @return [#call]
        #   The application that is being routed.
        #
        # @example Route requests going to an application.
        #   router.draw :ip => '210.18.0.0/16', :to => BannedApp
        #
        # @example Accept routed requests using a block.
        #   router.draw :ip => '210.18.0.0/16' do |request|
        #     response ['Banned!']
        #   end
        #
        # @since 0.3.0
        #
        def draw(options={},&block)
          app = (options.delete(:to) || block)

          return @routes[Rule.new(options)] = app
        end

        #
        # Filters requests based on the defined routes.
        #
        # @param [Hash, Rack::Request] env
        #   An incoming request.
        #
        # @return [Array, Response]
        #   A response.
        #
        # @since 0.3.0
        #
        def call(env)
          request = Rack::Request.new(env)

          @routes.each do |rule,app|
            if rule.match?(request)
              print_info "Routing #{request.uri}"
              return app.call(env)
            end
          end

          super(env)
        end

      end
    end
  end
end
