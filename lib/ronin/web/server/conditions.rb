#
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/target'

require 'ipaddr'

module Ronin
  module Web
    module Server
      module Conditions
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
          protected

          #
          # Condition to match the IP Address that sent the request.
          #
          # @param [IPAddr, String] ip
          #   The IP address or range of addresses to match against.
          #
          # @since 1.0.0
          #
          # @api semipublic
          #
          def ip_address(ip)
            ip = IPAddr.new(ip.to_s) unless ip.kind_of?(IPAddr)

            condition { ip.include?(request.ip) }
          end

          #
          # Condition to match the `Referer` header of the request.
          #
          # @param [Regexp, String] pattern
          #   Regular expression or exact Referer to match against.
          #
          # @since 1.0.0
          #
          # @api semipublic
          #
          def referer(pattern)
            condition do
              case pattern
              when Regexp
                request.referer =~ pattern
              else
                request.referer == pattern
              end
            end
          end

          #
          # Condition to match requests sent by an IP Address targeted by a
          # Campaign.
          #
          # @param [String] name
          #   The name of the Campaign to match IP Addresses against.
          #
          # @since 1.0.0
          #
          # @api semipublic
          #
          def campaign(name)
            condition do
              Target.first(
                'campaign.name'   => name,
                'address.address' => request.ip
              )
            end
          end
        end
      end
    end
  end
end
