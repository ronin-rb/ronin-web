#
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'nokogiri'

module Nokogiri
  module XML
    class Text < CharacterData

      #
      # Determines if the text node is similar to another text node.
      #
      # @param [Nokogiri::XML::Text] other
      #   The other text node.
      #
      # @return [Boolean]
      #   Specifies if the text node is similar, in indentity or value,
      #   to the other text node.
      #
      def ==(other)
        super(other) && (self.content == other.content)
      end

    end
  end
end
