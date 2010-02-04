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

require 'ronin/network/http'

module Ronin
  module Web
    module Server
      module Helpers
        module Proxy
          #
          # Proxies the current request.
          #
          # @param [Hash] options
          #   Additional options to use when proxying the request.
          #
          # @yield [(response), body]
          #   If a block is given, it will be passed the optional response
          #   of the proxied request and the body received from the
          #   proxied request.
          #
          # @yieldparam [Net::HTTP::Response] response
          #   The response of the proxied request.
          #
          # @yieldparam [String] body
          #   The body from the proxied request.
          #
          # @example
          #   get '/login.php' do
          #     proxy do |body|
          #       body.gsub(/https/,'http')
          #     end
          #   end
          #
          # @since 0.2.0
          #
          def proxy(options={},&block)
            default_options = {
              :host => request.host,
              :port => request.port,
              :method => request.request_method,
              :path => request.path_info,
              :query => request.query_string,
              :content_type => request.content_type
            }

            request.env.each do |name,value|
              if name =~ /^HTTP/
                default_options[name.gsub(/^HTTP_/,'').downcase.to_sym] = value
              end
            end
            
            options = default_options.merge(options)
            http_response = Net.http_request(options)

            response = Rack::Response.new(
              [http_response.body],
              http_response.code,
              http_response.to_hash
            )

            if block
              old_body = response.body.first

              new_body = if block.arity == 2
                block.call(response,old_body)
              else
                block.call(old_body)
              end

              response.body[0] = (new_body || old_body)
            end

            halt(response)
          end

          #
          # Proxies the current request.
          #
          # @param [Hash] options
          #   Additional options to use when proxying the request.
          #
          # @yield [(response), doc]
          #   If a block is given, it will be passed the optional response
          #   of the proxied request and the document representing the
          #   proxied request.
          #
          # @yieldparam [Net::HTTP::Response] response
          #   The response of the proxied request.
          #
          # @yieldparam [Nokogiri::HTML, Nokogiri::XML] doc
          #   The document representing the proxied request.
          #
          # @example
          #   get '/login.php' do
          #     proxy_doc do |response,doc|
          #       doc.search('form/@action').each do |action|
          #         action.inner_text = action.inner_text.gsub(
          #           /^https/, 'http'
          #         )
          #       end
          #     end
          #   end
          #
          # @since 0.2.0
          #
          def proxy_doc(options={},&block)
            proxy(options) do |response,body|
              case response.content_type
              when 'text/html'
                doc = Nokogiri::HTML(body)
              when 'text/xml'
                doc = Nokogiri::XML(body)
              else
                doc = nil
              end

              if doc
                if block
                  if block.arity == 2
                    block.call(response,doc)
                  else
                    block.call(doc)
                  end
                end

                doc.to_s
              end
            end
          end
        end
      end
    end
  end
end
