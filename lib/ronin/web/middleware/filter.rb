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
      # A Rack middleware for filtering requests based on predefined rules.
      #
      #     use Ronin::Web::Middleware::Filter do |filter|
      #       # filter requests by source IP address
      #       filter.rule :ip => '212.18.45.0/24', :to => BannedApp
      #       filter.rule :ip => '192.168.0.0/16' do |request|
      #         response ['Nothing here'], 404
      #       end
      #
      #       # filter requests by Referer URL
      #       filter.rule :referer => 'http://www.sexy.com/', :to => TrapApp
      #       filter.rule :referer => /\.google\./ do |request|
      #         response ['Nothing to see here.'], 404
      #       end
      #
      #       # filter requests by User-Agent
      #       filter.rule :user_agent => /Microsoft/, :to => IEApp
      #
      #       # filter requests using custom logic
      #       filter.rule :when => lambda { |request| request.form_data? },
      #                   :to => FormApp
      #
      #       # mix filter options together
      #       filter.rule :ip => '212.18.45.0/24', :user_agent => /Microsoft/, :to => PwnApp
      #     end
      #
      class Filter < Base

        # The rules to filter requests by
        attr_reader :rules

        #
        # Creates a new Filter middleware.
        #
        # @param [#call] app
        #   The application that the filter sits in front of.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @yield [filter]
        #   If a block is given, it will be passed the newly created
        #   filter middleware.
        #
        # @yieldparam [Filter] filter
        #   The new filter middleware object.
        #
        # @since 0.3.0
        #
        def initialize(app,options={},&block)
          @rules = {}

          super(app,options,&block)
        end

        #
        # Defines a rule to filter requests by.
        #
        # @param [Hash] options
        #   Filter options.
        #
        # @option options [String] :campaign
        #   The name of the campaign who's targetted hosts will be filtered.
        #
        # @option options [String, Regexp] :vhost
        #   The Virtual-Host to filter for.
        #
        # @option options [String, IPAddr] :ip
        #   The IP address or IP range to fitler.
        #
        # @option options [String, Regexp] :referer
        #   The Referer URL or pattern to filter.
        #
        # @option options [String, Regexp] :user_agent
        #   The User-Agent string to filter.
        #
        # @option options [Proc] :when
        #   Custom logic to use when filtering requests.
        #
        # @option options [#call] :to
        #   The application that will receive filtered requests.
        #
        # @yield [request]
        #   If a block is given, it will receive filtered requests.
        #
        # @yieldparam [Rack::Request] request
        #   A filtered request.
        #
        # @return [Rule]
        #   The new filter rule.
        #
        # @example Filter requests going to an application.
        #   filter.rule :ip => '210.18.0.0/16', :to => BannedApp
        #
        # @example Accept filtered requests using a block.
        #   filter.rule :ip => '210.18.0.0/16' do |request|
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
