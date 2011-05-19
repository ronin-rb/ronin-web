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

module Ronin
  module Web
    module Middleware
      module Filters
        #
        # A Filter to match requests based on their HTTP Referer URL.
        #
        class RefererFilter

          #
          # Creates a new HTTP Referer filter.
          #
          # @param [String, Regexp] referer
          #   The HTTP Referer URL pattern to match against.
          #
          # @since 0.3.0
          #
          def initialize(referer)
            @referer = referer
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
            if @referer.kind_of?(Regexp)
              !((request.referer =~ @referer).nil?)
            else
              request.referer == @referer
            end
          end

        end
      end
    end
  end
end
