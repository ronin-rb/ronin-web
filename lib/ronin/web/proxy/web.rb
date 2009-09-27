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

require 'ronin/web/proxy/app'

module Ronin
  module Web
    #
    # Returns the Ronin Web Proxy. When called for the first time
    # the proxy will be started in the background.
    #
    # @see Server::Base.run!
    #
    def Web.proxy_server(options={},&block)
      unless class_variable_defined?('@@ronin_web_proxy')
        @@ronin_web_proxy = Proxy::App
        @@ronin_web_proxy.run!(options.merge(:background => true))
      end

      @@ronin_web_proxy.class_eval(&block)

      return @@ronin_web_proxy
    end
  end
end
