#
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
#

require 'ronin/web/server/helpers/proxy'

module Ronin
  module Web
    module Server
      module Proxy
        def self.included(base)
          base.module_eval do
            #
            # Proxies requests to a given path.
            #
            # @param [String] path
            #   The path to proxy requests for.
            #
            # @param [Hash] options
            #   Additional options.
            # 
            # @yield [(response), body]
            #   If a block is given, it will be passed the optional
            #   response of the proxied request and the body received
            #   from the proxied request.
            #
            # @yieldparam [Net::HTTP::Response] response
            #   The response.
            #
            # @yieldparam [String] body
            #   The body from the response.
            #
            # @example
            #   proxy '/login.php' do |body|
            #     body.gsub(/https/,'http')
            #   end
            #
            # @example
            #   proxy '/login*' do |response,body|
            #   end
            #
            # @since 0.2.0
            #
            def self.proxy(path,options={},&block)
              any(path) do
                proxy(options,&block)
              end
            end

            #
            # Proxies requests to a given path.
            #
            # @param [String] path
            #   The path to proxy requests for.
            #
            # @param [Hash] options
            #   Additional options.
            # 
            # @yield [(response), page]
            #   If a block is given, it will be passed the optional
            #   response of the proxied request and the page from the
            #   proxied request.
            #
            # @yieldparam [Net::HTTP::Response] response
            #   The response.
            #
            # @yieldparam [Nokogiri::HTML, Nokogiri::XML] page
            #   The page from the response.
            #
            # @example
            #   proxy_page '/login.php' do |page|
            #     body.search('@action').each do |action|
            #       action.inner_text = action.inner_text.gsub(
            #         /https/, 'http'
            #       )
            #     end
            #   end
            #
            # @example
            #   proxy_page '/login*' do |response,body|
            #   end
            #
            # @since 0.2.0
            #
            def self.proxy_page(path,options={},&block)
              any(path) do
                proxy_page(options,&block)
              end
            end

            protected

            helpers Ronin::Web::Server::Helpers::Proxy
          end
        end
      end
    end
  end
end
