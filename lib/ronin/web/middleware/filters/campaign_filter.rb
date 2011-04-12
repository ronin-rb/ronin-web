#
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/campaign'
require 'ronin/ip_address'

module Ronin
  module Web
    module Middleware
      module Filters
        #
        # A Filter used to match requests coming from IP Addresses that are
        # targeted by a specified Campaign.
        #
        class CampaignFilter

          #
          # Creates a new campaign filter.
          #
          # @param [String] name
          #   The name of the campaign to match against.
          #
          # @raise [RuntimeError]
          #   No campaign with the given name.
          #
          # @since 0.3.0
          #
          def initialize(name)
            @name = name.to_s
          end

          #
          # Matches the filter against the request.
          #
          # @param [Rack::Request] request
          #   The incoming request.
          #
          # @return [Boolean]
          #   Specifies whether the filter matched the request.
          #
          # @since 0.3.0
          #
          def match?(request)
            Campaign.count(
              :name => @name,
              Campaign.addresses.address => request.ip
            ) == 1
          end

        end
      end
    end
  end
end
