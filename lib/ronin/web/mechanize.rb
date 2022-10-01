#
# ronin-web - A collection of useful web helper methods and commands.
#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-web.
#
# ronin-web is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-web is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with ronin-web.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/web/config'

require 'mechanize'

module Ronin
  module Web
    #
    # Convenience class based on Mechanize.
    #
    # @see http://rubydoc.info/gems/mechanize/Mechanize
    #
    class Mechanize < ::Mechanize

      #
      # Creates a new [Mechanize](http://mechanize.rubyforge.org/) Agent.
      #
      # @param [Network::HTTP::Proxy, Hash, String] proxy
      #   Proxy information.
      #
      # @param [String, :random, :chrome, :chrome_linux, :chrome_macos,
      #         :chrome_windows, :chrome_iphone, :chrome_ipad,
      #         :chrome_android, :firefox, :firefox_linux, :firefox_macos,
      #         :firefox_windows, :firefox_iphone, :firefox_ipad,
      #         :firefox_android, :safari, :safari_macos, :safari_iphone,
      #         :safari_ipad, :edge, :linux, :macos, :windows, :iphone,
      #         :ipad, :android, nil] user_agent
      #   The `User-Agent` string to use.
      #
      # @yield [agent]
      #   If a block is given, it will be passed the newly created Mechanize
      #   agent.
      #
      # @yieldparam [Mechanize] agent
      #   The new Mechanize agent.
      #
      def initialize(proxy: Web.proxy, user_agent: Web.user_agent)
        super()

        if proxy
          proxy = URI(proxy)

          set_proxy(proxy.host,proxy.port,proxy.user,proxy.password)
        end

        if user_agent
          self.user_agent = case user_agent
                            when Symbol
                              Support::Network::HTTP::UserAgents[user_agent]
                            else
                              user_agent
                            end
        end

        yield self if block_given?
      end

    end
  end
end
