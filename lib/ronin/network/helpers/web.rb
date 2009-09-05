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

require 'ronin/network/helpers/helper'
require 'ronin/network/http/proxy'
require 'ronin/web/web'

module Ronin
  module Network
    module Helpers
      module Web
        include Helper

        protected

        def web_proxy
          HTTP::Proxy.new(
            :host => @web_proxy_host,
            :port => @web_proxy_port,
            :user => @web_proxy_user,
            :password => @web_proxy_password
          )
        end

        def web_agent(options={},&block)
          unless @web_agent
            options[:proxy] ||= web_proxy
            options[:user_agent] ||= @web_user_agent

            @web_agent = Ronin::Web.agent(options,&block)
          end

          return @web_agent
        end

        def web_get(uri,options={},&block)
          page = web_agent(options).get(uri)

          block.call(page) if block
          return page
        end

        def web_get_body(uri,options={},&block)
          body = web_agent(options).get(uri).body

          block.call(body) if block
          return body
        end

        def web_post(uri,options={},&block)
          page = web_agent(options).post(uri)

          block.call(page) if block
          return page
        end

        def web_post_body(uri,options={},&block)
          body = web_agent(options).post(uri).body

          block.call(body) if block
          return body
        end
      end
    end
  end
end
