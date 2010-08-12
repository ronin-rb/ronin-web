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

require 'ronin/network/http/http'

module Ronin
  module Web
    module Middleware
      class Response < Struct.new(:status, :headers, :body)

        #
        # Provides transparent access to the headers of the response.
        #
        # @param [String, Symbol, Integer] member_or_header
        #   The member or header name to access.
        #
        # @return [Object]
        #   The member or header.
        #
        # @since 0.2.2
        #
        def [](member_or_header)
          case member_or_header
          when Symbol, String
            unless self.members.include?(member_or_header.to_sym)
              header = Network::HTTP.header_name(member_or_header)
              return self.headers[header]
            end
          end

          super(member_or_header)
        end

        #
        # Provides transparent access to setting the headers of the response.
        #
        # @param [String, Symbol, Integer] member_or_header
        #   The member or header name to set.
        #
        # @param [Object] value
        #   The value to set.
        #
        # @return [Object]
        #   The set value.
        #
        # @since 0.2.2
        #
        def []=(member_or_header,value)
          case member_or_header
          when Symbol, String
            unless self.members.include?(member_or_header.to_sym)
              header = Network::HTTP.header_name(member_or_header)
              return self.headers[header] = value
            end
          end

          super(member_or_header,value)
        end

        protected

        #
        # Provides transparent access to the headers of the response.
        #
        # @param [Symbol] name
        #   The method being called.
        #
        # @param [Array] arguments
        #   The arguments of the method call.
        #
        # @return [Object]
        #   The return value of the method call.
        #
        # @see #[]
        # @see #[]=
        #
        # @since 0.2.2
        #
        def method_missing(name,*arguments,&block)
          if block.nil?
            header_name = name.to_s

            if (header_name[-1..-1] == '=' && arguments.length == 1)
              return self[header_name[0..-2]] = arguments[0]
            elsif arguments.empty?
              return self[header_name]
            end
          end

          super(name,*arguments,&block)
        end

      end
    end
  end
end
