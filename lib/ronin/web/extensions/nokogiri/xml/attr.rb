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
    class Attr < Node

      #
      # Determines if the attribute is similar to another attribute.
      #
      # @param [Nokogiri::XML::Attr] other
      #   The other attribute.
      #
      # @return [Boolean]
      #   Specifies if the attribute is similar, in identity or value,
      #   to the other attribute.
      #
      # @api public
      #
      def ==(other)
        super(other) && (self.value == other.value)
      end

    end
  end
end
