#
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-web.
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
# along with Ronin.  If not, see <https://www.gnu.org/licenses/>.
#

require 'nokogiri'

module Nokogiri
  module XML
    class Node

      #
      # Calculates the sum of all children of the node.
      #
      # @return [Integer]
      #   The total number of children of the node.
      #
      # @api public
      #
      def total_children
        count = 0

        traverse { |node| count += 1 }

        return count - 1
      end

      #
      # Traverses all text nodes which are children of the node.
      #
      # @yield [node]
      #   A block will be passed each text node.
      #
      # @yieldparam [Nokogiri::XML::Text] node
      #   A text node.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      # @api public
      #
      def traverse_text
        return enum_for(:traverse_text) unless block_given?

        yield self if text?

        traverse do |node|
          yield node if node.text?
        end
      end

      #
      # Determines if the node is similar to another node.
      #
      # @return [Boolean]
      #   Specifies whether the node is equal, in identity or value, to
      #   another node.
      #
      # @api public
      #
      def ==(other)
        return false unless other

        (self.type == other.type) && (self.name == other.name)
      end

    end
  end
end
