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
      # @option options [String] :user_agent
      #   The User-Agent string to send.
      #
      # @option options [String] :referer
      #   The referer URL to send.
      #
      # @option options [Integer] :delay (0)
      #   Duration in seconds to pause between spidering each link.
      #
      # @option options [String, Regexp] :host
      #   The host-name to visit.
      #
      # @option options [Array] :hosts
      #   Patterns of host-names to visit.
      #
      # @option options [Array] :ignore_hosts
      #   Patterns of host-names not to visit.
      #
      # @option options [Array] :ports
      #   Ports to visit.
      #
      # @option options [Array] :ignore_ports
      #   Ports not to visit.
      #
      # @option options [Array] :links
      #   Patterns of links to visit.
      #
      # @option options [Array] :ignore_links
      #   Patterns of links not to visit.
      #
      # @option options [Array] :ext
      #   Patterns of file extensions to accept.
      #
      # @option options [Array] :ignore_exts
      #   Patterns of file extensions to ignore.
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
