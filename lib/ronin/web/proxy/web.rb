#
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/web/proxy/proxy'

module Ronin
  module Web
    #
    # Creates a new Proxy server and runs it.
    #
    # @param [Hash] options
    #   Additional options for running the proxy.
    #
    # @yield [proxy]
    #   The block will be passed the new proxy server.
    #
    # @yieldparam [Proxy] proxy
    #   The new proxy instance to be configured.
    #
    # @see Proxy#initialize
    # @see Proxy#run!
    #
    # @api public
    #
    def Web.proxy_server(options={},&block)
      Proxy.new(&block).run!(options)
    end
  end
end
