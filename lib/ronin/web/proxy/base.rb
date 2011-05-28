#
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/web/server/base'
require 'ronin/web/middleware/proxy'

module Ronin
  module Web
    module Proxy
      #
      # The base-class for all Ronin Web Proxies. Extends
      # [Sinatra::Base](http://rubydoc.info/gems/sinatra/Sinatra/Base)
      # with {Middleware::Proxy}.
      #
      class Base < Server::Base

        # The default port to run the Web Proxy on
        DEFAULT_PORT = 8080

        set :port, DEFAULT_PORT

        use Middleware::Proxy

      end
    end
  end
end
