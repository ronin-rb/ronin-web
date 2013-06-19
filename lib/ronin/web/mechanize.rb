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

require 'ronin/web/web'
require 'ronin/network/http/proxy'

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
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String] :user_agent
      #   The User-Agent string to use.
      #
      # @option options [String] :user_agent_alias
      #   The User-Agent Alias to use.
      #
      # @option options [Network::HTTP::Proxy, Hash, String] :proxy (Web.proxy)
      #   Proxy information.
      #
      # @yield [agent]
      #   If a block is given, it will be passed the newly created Mechanize
      #   agent.
      #
      # @yieldparam [Mechanize] agent
      #   The new Mechanize agent.
      #
      def initialize(options={})
        super()

        if options[:user_agent_alias]
          self.user_agent_alias = options[:user_agent_alias]
        elsif options[:user_agent]
          self.user_agent = options[:user_agent]
        elsif Web.user_agent
          self.user_agent = Web.user_agent
        end

        proxy = Network::HTTP::Proxy.new(options[:proxy] || Web.proxy)

        if proxy[:host]
          set_proxy(
            proxy[:host],
            proxy[:port],
            proxy[:user],
            proxy[:password]
          )
        end

        yield self if block_given?
      end

    end
  end
end
