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

require 'ipaddr'

module Ronin
  module Web
    module Middleware
      #
      # Represents a rule used in the {Filter} middleware.
      #
      class Rule

        # The Virtual-Host to filter for.
        attr_reader :vhost

        # The IP address to filter for.
        attr_reader :ip

        # The Referer URL to filter for.
        attr_reader :referer

        # The User-Agent string to filter for.
        attr_reader :user_agent

        # Custom logic to use for filtering requests.
        attr_reader :when

        #
        # Creates a new {Filter} rule.
        #
        # @param [Hash] options
        #   Filtering options.
        #
        # @option options [String, Regexp] :vhost
        #   The Virtual-Host to filter for.
        #
        # @option options [String, IPAddr] :ip
        #   The IP address or range to filter.
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
        # @since 0.2.2
        #
        def initialize(options={})
          @vhost = options[:vhost]

          if (raw_ip = options[:ip])
            @ip = unless raw_ip.kind_of?(IPAddr)
                    IPAddr.new(raw_ip)
                  else
                    raw_ip
                  end
          end

          @referer = options[:referer]
          @user_agent = options[:user_agent]
          @when = options[:when]
        end

        #
        # Determines if a request matches the filter rule.
        #
        # @param [Rack::Request] request
        #   An incoming request.
        #
        # @return [Boolean]
        #   Specifies whether the request matches the filter rule.
        #
        # @since 0.2.2
        #
        def match?(request)
          matched = true

          if @vhost
            matched &&= if @vhost.kind_of?(Regexp)
                          request.host =~ @vhost
                        else
                          request.host == @vhost
                        end
          end

          if @ip
            matched &&= @ip.include?(request.ip)
          end

          if (request.referer && @referer)
            matched &&= if @referer.kind_of?(Regexp)
                         request.referer =~ @referer
                       else
                         request.referer == @referer
                       end
          end

          if (request.user_agent && @user_agent)
            matched &&= request.user_agent.match(@user_agent)
          end

          if @when
            matched &&= @when.call(request)
          end

          return matched
        end

      end
    end
  end
end
