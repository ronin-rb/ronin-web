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

require 'ronin/support/network/http'
require 'ronin/support/network/http/user_agents'

module Ronin
  module Web
    #
    # Proxy information for {Web} to use.
    #
    # @return [URI::HTTP, String, nil]
    #   The default proxy information.
    #
    # @see http://rubydoc.info/gems/ronin-support/Ronin/Support/Network/HTTP#proxy-class_method
    #
    # @api public
    #
    def self.proxy
      @proxy || Support::Network::HTTP.proxy
    end

    #
    # Sets the proxy used by {Web}.
    #
    # @param [URI::HTTP, String, nil] new_proxy
    #   The new proxy information to use.
    #
    # @return [URI::HTTP, String, nil]
    #   The new proxy.
    #
    # @raise [ArgumentError]
    #   The given proxy information was not a `URI::HTTP`, `String`, or
    #   `nil`.
    #
    # @since 0.3.0
    #
    # @api public
    #
    def self.proxy=(new_proxy)
      @proxy = case new_proxy
               when URI::HTTP then new_proxy
               when String    then URI.parse(new_proxy)
               when nil       then nil
               else
                 raise(ArgumentError,"invalid proxy value (#{new_proxy.inspect}), must be either a URI::HTTP, String, or nil")
               end
    end

    #
    # The User-Agent string used by {Web}.
    #
    # @return [String, nil]
    #   The default `User-Agent` string that `ronin-web` will use.
    #
    # @see http://rubydoc.info/gems/ronin-support/Ronin/Support/Network/HTTP#user_agent-class_method
    #
    # @api public
    #
    def self.user_agent
      @user_agent || Support::Network::HTTP.user_agent
    end

    #
    # Sets the `User-Agent` string used by {Web}.
    #
    # @param [String, :random, :chrome, :chrome_linux, :chrome_macos,
    #         :chrome_windows, :chrome_iphone, :chrome_ipad,
    #         :chrome_android, :firefox, :firefox_linux, :firefox_macos,
    #         :firefox_windows, :firefox_iphone, :firefox_ipad,
    #         :firefox_android, :safari, :safari_macos, :safari_iphone,
    #         :safari_ipad, :edge, :linux, :macos, :windows, :iphone,
    #         :ipad, :android, nil] value
    #   The new `User-Agent` string to use.
    #   Setting {user_agent} to `nil` will disable the `User-Agent` string.
    #
    # @return [String]
    #   The new User-Agent string.
    #
    # @raise [RuntimeError]
    #   Either no User-Agent group exists with the given `Symbol`,
    #   or no User-Agent string matched the given `Regexp`.
    #
    # @example Sets the default User-Agent
    #   Web.user_agent = 'SearchBot 2000'
    #   # => "SearchBot 2000"
    #
    # @example Select a random User-Agent with the matching sub-string
    #   Web.user_agent = 'Chrome'
    #   # => "Mozilla/5.0 (Linux; U; en-US) AppleWebKit/525.13 (KHTML, like Gecko) Chrome/0.2.149.27 Safari/525.13"
    #
    # @example Select a random User-Agent matching the Regexp
    #   Web.user_agent = /(MSIE|Windows)/
    #   # => "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; InfoPath.1)"
    #
    # @example Select a random User-Agent from a category
    #   Web.user_agent = :googlebot
    #   # => "Googlebot-Image/1.0 ( http://www.googlebot.com/bot.html)"
    #
    # @see Web.user_agents
    #
    # @api public
    #
    def self.user_agent=(value)
      @user_agent = case value
                    when String then value
                    when Symbol then Support::Network::HTTP::UserAgents[value]
                    when nil    then nil
                    else
                      raise(ArgumentError,"invalid user_agent value (#{value.inspect}), must be a String, Symbol, or nil")
                    end
    end
  end
end
