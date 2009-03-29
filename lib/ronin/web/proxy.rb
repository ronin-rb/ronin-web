#
#--
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

require 'ronin/web/server'
require 'ronin/network/http'

require 'net/http'

module Ronin
  module Web
    class Proxy < Server

      # The default HTTP Request to use
      DEFAULT_HTTP_REQUEST = Net::HTTP::Get

      #
      # Creates a new Web Proxy using the given configuration _block_.
      #
      # _options_ may contain the following keys:
      # <tt>:host</tt>:: The host to bind to.
      # <tt>:port</tt>:: The port to listen on.
      # <tt>:config</tt>:: A +Hash+ of configurable variables to be used
      #                    in responses.
      #
      def initialize(options={},&block)
        super(options)

        @default = method(:proxy)

        instance_eval(&block) if block
      end

      #
      # Proxies the specified Rack _request_ and returns a corresponding
      # Rack response.
      #
      def proxy(request)
        server_response = http_response(request)
        server_headers = server_response.to_hash
        body = (server_response.body || '')

        return response(body,server_headers)
      end

      protected

      #
      # Returns the Net::HTTP Request class that represents the specified
      # HTTP _request_method_.
      #
      #   http_class('POST')
      #   # => Net::HTTP::Post
      #
      def http_class(request_method)
        http_method = request_method.downcase.capitalize
        http_class = DEFAULT_HTTP_REQUEST

        if Net::HTTP.const_defined?(http_method)
          http_class = Net::HTTP.const_get(http_method)

          unless http_class.kind_of?(Net::HTTPRequest)
            http_class = DEFAULT_HTTP_REQUEST
          end
        end

        return http_class
      end

      #
      # Converts the Rack headers within the specified _request_ to
      # Net::HTTP formatted HTTP headers.
      #
      def http_headers(request)
        client_headers = {}

        request.env.each do |name,value|
          if name =~ /^HTTP_/
            header_name = name.gsub(/^HTTP_/,'').split('_').map { |word|
              word.capitalize
            }.join('-')

            client_headers[header_name] = value
          end
        end

        return client_headers
      end

      #
      # Returns the Net::HTTP response for the specified Rack _request_.
      # 
      def http_response(request)
        path = request.fullpath
        http_method = http_class(request.request_method)
        client_request = http_method.new(path,http_headers(request))

        Net.http_session(:host => request.host, :port => request.port) do |http|
          return http.request(client_request)
        end
      end

    end
  end
end
