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

require 'rack/request'

module Ronin
  module Web
    module Middleware
      class Request < Rack::Request

        def host=(new_host)
          @env['HTTP_HOST'] = @env['SERVER_NAME'] = new_host
        end

        def port=(new_port)
          @env['SERVER_PORT'] = new_port
        end

        def request_method=(new_method)
          @env['REQUEST_METHOD'] = new_method
        end

        def path=(new_path)
          @env['PATH_INFO'] = new_path
        end

        def query_string=(new_query)
          @env['QUERY_STRING'] = new_query
        end

        def xhr!
          @env['HTTP_X_REQUESTED_WITH'] = 'XMLHttpRequest'
          return true
        end

        def content_type=(new_content_type)
          @env['CONTENT_TYPE'] = new_content_type
        end

        def accept_encoding=(new_encoding)
          @env['HTTP_ACCEPT_ENCODING'] = new_encoding
        end

        def referer=(new_referer)
          @env['HTTP_REFERER'] = new_referer
        end

        alias referrer= referer=

        def body
          (@body || super)
        end

        def body=(new_body)
          @body = new_body
        end

      end
    end
  end
end
