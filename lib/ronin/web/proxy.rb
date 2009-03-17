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
require 'ronin/ui/diagnostics'

require 'net/http'

module Ronin
  module Web
    class Proxy < Server

      include UI::Diagnostics

      #
      # Creates a new Web Server using the given configuration _block_.
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

      def proxy(env)
        response = http_response(env)
        headers = Rack::Utils::HeaderHash.new(response.to_hash)

        print_info "Status Code: #{response.code}"
        print_info "Response Headers: #{headers.inspect}"

        body = response.body

        if body
          print_info "Response body:\n#{body}"
        end

        return [response.code, headers, (body || '')]
      end

      protected

      def http_class(env)
        http_method = env['REQUEST_METHOD'].downcase.capitalize
        http_class = Net::HTTP::Get

        if Net::HTTP.const_defined?(http_method)
          http_class = Net::HTTP.const_get(http_method)

          unless http_class.kind_of?(Net::HTTPRequest)
            http_class = Net::HTTP::Get
          end
        end

        return http_class
      end

      def http_headers(env)
        headers = {}

        env.each do |name,value|
          if name =~ /^HTTP_/
            header_name = name.gsub(/^HTTP_/,'').split('_').map { |word|
              word.capitalize
            }.join('-')

            headers[header_name] = value
          end
        end

        print_info "Request Headers: #{headers.inspect}"

        return headers
      end

      def http_response(env)
        url = URI(env['REQUEST_URI'].to_s)

        path = url.path
        path = "#{path}?#{url.query}" if url.query

        print_info "Path: #{path}"

        request = http_class(env).new(path,http_headers(env))

        Net.http_session do |http|
          return http.request(request)
        end
      end

    end
  end
end
