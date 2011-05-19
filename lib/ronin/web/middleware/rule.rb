#
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Web.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/web/middleware/filters'

module Ronin
  module Web
    module Middleware
      #
      # Matches requests against one or more filters.
      #
      class Rule

        # Registered filters
        FILTERS = {
          :ip => Filters::IPFilter,
          :campaign => Filters::CampaignFilter,
          :path => Filters::PathFilter,
          :vhost => Filters::VHostFilter,
          :referer => Filters::RefererFilter,
          :user_agent => Filters::UserAgentFilter
        }

        #
        # Creates a new rule.
        #
        # @param [Hash] options
        #   Additional filtering options for the rule.
        #
        # @option options [String] :campaign
        #   The name of the campaign who's targetted hosts will be
        #   filtered by.
        #
        # @option options [String, Regexp] :vhost
        #   The Virtual-Host to filter.
        #
        # @option options [String, IPAddr] :ip
        #   The IP address or IP range to filter.
        #
        # @option options [String, Regexp] :referer
        #   The Referer URL or pattern to filter.
        #
        # @option options [String, Regexp] :user_agent
        #   The User-Agent string to filter.
        #
        # @option options [Proc] :when
        #   Custom logic to filter requests by.
        #
        # @since 0.3.0
        #
        def initialize(options={},&block)
          @filters = []
          @when_block = options.delete(:when)

          options.each do |name,value|
            if FILTERS.has_key?(name)
              @filters << FILTERS[name].new(value)
            end
          end
        end

        #
        # Matches a request against the rule.
        #
        # @param [Rack::Request] request
        #   The request to match.
        #
        # @return [Boolean]
        #   Specifies if the request matches all of the filters.
        #
        def match?(request)
          @filters.all? { |filter| 
            filter.match?(request)
          } && (@when_block.nil? || (@when_block.call(request) ? true : false))
        end

      end
    end
  end
end
