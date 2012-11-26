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

require 'ronin/network/http/http'

require 'sinatra/base'

module Ronin
  module Web
    module Server
      #
      # Convenience class that represents requests.
      #
      # @see http://rubydoc.info/gems/rack/Rack/Request
      #
      class Request < Sinatra::Request

        #
        # Returns the remote IP address and port for the request.
        #
        # @param [Hash] env
        #   The request env Hash.
        #
        # @return [String]
        #   The IP address and port number.
        #
        # @since 0.3.0
        #
        # @api semipublic
        #
        def address
          if env.has_key?('REMOTE_PORT')
            "#{ip}:#{env['REMOTE_PORT']}"
          else
            ip
          end
        end

        #
        # The HTTP Headers for the request.
        #
        # @return [Hash{String => String}]
        #   The HTTP Headers of the request.
        #
        # @since 0.3.0
        #
        # @api public
        #
        def headers
          headers = {}

          env.each do |name,value|
            if name =~ /^HTTP_/
              header_name = Network::HTTP.header_name(name.sub('HTTP_',''))
              headers[header_name] = value
            end
          end

          return headers
        end

      end
    end
  end
end
