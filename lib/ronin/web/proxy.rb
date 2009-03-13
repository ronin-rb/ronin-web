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

require 'net/http'

module Ronin
  module Web
    class Proxy < Server

      def proxy(env)
        response = http_response(env['REQUEST_URI'],env)
        headers = Rack::Utils::HeaderHash.new(response.to_hash)

        STDERR.puts "Status Code: #{response.code}"
        STDERR.puts "Response Headers: #{headers.inspect}"

        body = response.body

        STDERR.puts "Response body:\n#{body}" if body

        [response.code, headers, (body || '')]
      end

      protected

      def http_class(env)
        http_method = env['REQUEST_METHOD'].downcase.capitalize
        http_class = Net::HTTP::Get

        if Net::HTTP.const_defined?(http_method)
          http_class = Net::HTTP.const_get(http_method)
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

        STDERR.puts "Request Headers: #{headers.inspect}"

        return headers
      end

      def http_response(url,env)
        url = URI(url.to_s)

        path = url.path
        path = "#{path}?#{url.query}" if url.query

        STDERR.puts "Path: #{path}"

        request = http_class(env).new(path, http_headers(env))

        return Net::HTTP.start(url.host, url.port) do |http|
          http.request(request)
        end
      end

    end
  end
end
