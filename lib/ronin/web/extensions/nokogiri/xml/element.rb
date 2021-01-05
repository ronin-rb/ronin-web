#
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
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
    class Element < Node

      #
      # Determines if the element is similar to another element.
      #
      # @param [Nokogiri::XML::Element] other
      #   The other element.
      #
      # @return [Boolean]
      #   Specifies whether the element is equal, in identity or value, to
      #   another element.
      #
      # @api public
      #
      def ==(other)
        return false unless super(other)
        return false unless attribute_nodes.length == other.attribute_nodes.length

        (0...attribute_nodes.length).each do |index|
          attr1 = attribute_nodes[index]
          attr2 = other.attribute_nodes[index]

          return false unless attr1.similar?(attr2)
        end

        return true
      end

    end
  end
end
