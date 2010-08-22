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
require 'ronin/web/middleware/rule'

module Ronin
  module Web
    module Middleware
      #
      # A Rack middleware for routing requests based on predefined rules.
      #
      #     use Ronin::Web::Middleware::Router do |router|
      #       # route requests by source IP address
      #       router.rule :ip => '212.18.45.0/24', :to => BannedApp
      #       router.rule :ip => '192.168.0.0/16' do |request|
      #         response ['Nothing here'], 404
      #       end
      #
      #       # route requests by Referer URL
      #       router.rule :referer => 'http://www.sexy.com/', :to => TrapApp
      #       router.rule :referer => /\.google\./ do |request|
      #         response ['Nothing to see here.'], 404
      #       end
      #
      #       # route requests by User-Agent
      #       router.rule :user_agent => /Microsoft/, :to => IEApp
      #
      #       # route requests using custom logic
      #       router.rule :when => lambda { |request| request.form_data? },
      #                   :to => FormApp
      #
      #       # mix route options together
      #       router.rule :ip => '212.18.45.0/24',
      #                   :user_agent => /Microsoft/, :to => PwnApp
      #     end
      #
      class Router < Base

        # The rules to router requests by
        attr_reader :rules

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
          @rules = {}

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
        #   Custom logic to use when routing requests.
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
        # @return [Rule]
        #   The new router rule.
        #
        # @example Route requests going to an application.
        #   router.rule :ip => '210.18.0.0/16', :to => BannedApp
        #
        # @example Accept routed requests using a block.
        #   router.rule :ip => '210.18.0.0/16' do |request|
        #     response ['Banned!']
        #   end
        #
        # @see Rule#initialize
        #
        # @since 0.3.0
        #
        def rule(options={},&block)
          app = (options.delete(:to) || block)
          rule = Rule.new(options)

          @rules[rule] = app
          return rule
        end

        #
        # Filters requests based on the defined rules.
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

          @rules.each do |rule,app|
            return app.call(env) if rule.match?(request)
          end

          super(env)
        end

      end
    end
  end
end
