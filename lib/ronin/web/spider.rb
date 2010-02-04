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

require 'ronin/web/web'
require 'ronin/ui/output/helpers'

require 'spidr/agent'

module Ronin
  module Web
    class Spider < Spidr::Agent

      include UI::Output::Helpers

      #
      # Creates a new Spider object.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Hash] :proxy (Web.proxy)
      #   The proxy to use while spidering.
      #
      # @option options [String] :user_agent (Web.user_agent)
      #   The User-Agent string to send.
      #
      # @option options [String] :referer
      #   The referer URL to send.
      #
      # @option options [Integer] :delay (0)
      #   Duration in seconds to pause between spidering each link.
      #
      # @option options [Array] :schemes (['http', 'https'])
      #   The list of acceptable URI schemes to visit.
      #   The `https` scheme will be ignored if `net/https` cannot be
      #   loaded.
      #
      # @option options [String] :host
      #   The host-name to visit.
      #
      # @option options [Array<String, Regexp, Proc>] :hosts
      #   The patterns which match the host-names to visit.
      #
      # @option options [Array<String, Regexp, Proc>] :ignore_hosts
      #   The patterns which match the host-names to not visit.
      #
      # @option options [Array<Integer, Regexp, Proc>] :ports
      #   The patterns which match the ports to visit.
      #
      # @option options [Array<Integer, Regexp, Proc>] :ignore_ports
      #   The patterns which match the ports to not visit.
      #
      # @option options [Array<String, Regexp, Proc>] :links
      #   The patterns which match the links to visit.
      #
      # @option options [Array<String, Regexp, Proc>] :ignore_links
      #   The patterns which match the links to not visit.
      #
      # @option options [Array<String, Regexp, Proc>] :exts
      #   The patterns which match the URI path extensions to visit.
      #
      # @option options [Array<String, Regexp, Proc>] :ignore_exts
      #   The patterns which match the URI path extensions to not visit.
      #
      # @yield [spider]
      #   If a block is given, it will be passed the newly created spider.
      #
      # @yieldparam [Spider] spider
      #   The newly created spider.
      #
      # @see http://spidr.rubyforge.org/docs/classes/Spidr/Agent.html
      #
      def initialize(options={},&block)
        options = {
          :proxy => Web.proxy,
          :user_agent => Web.user_agent
        }.merge(options)

        super(options)

        every_url do |url|
          print_info("Spidering #{url}")
        end

        block.call(self) if block
      end

    end
  end
end
