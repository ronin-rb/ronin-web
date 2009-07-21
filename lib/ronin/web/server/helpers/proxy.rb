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

module Ronin
  module Web
    module Server
      module Helpers
        module Proxy
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
            response, body = Net.http_request(options)

            if block
              if block.arity == 2
                body = (block.call(response,body) || body)
              else
                body = (block.call(response) || body)
              end
            end

            return body
          end

          def proxy_page(options={},&block)
            proxy(options) do |response,body|
              case response.content_type
              when 'text/html'
                page = Nokogiri::HTML(body)
              when 'text/xml'
                page = Nokogiri::HTML(body)
              else
                page = response.body
              end

              if block
                page = (block.call(response,page) || page)
              end

              page.to_s
            end
          end
        end
      end
    end
  end
end
