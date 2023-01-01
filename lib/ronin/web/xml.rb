#
# ronin-web - A collection of useful web helper methods and commands.
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'nokogiri'

module Ronin
  module Web
    #
    # XML helper methods.
    #
    # @since 1.0.0
    #
    module XML
      #
      # Parses the body of a document into a HTML document object.
      #
      # @param [String, IO] xml
      #   The XML to parse.
      #
      # @yield [doc]
      #   If a block is given, it will be passed the newly created document
      #   object.
      #
      # @yieldparam [Nokogiri::XML::Document] doc
      #   The new XML document object.
      #
      # @return [Nokogiri::XML::Document]
      #   The new HTML document object.
      #
      # @see http://rubydoc.info/gems/nokogiri/Nokogiri/XML/Document
      #
      # @api public
      #
      def self.parse(xml)
        doc = Nokogiri::XML.parse(xml)
        yield doc if block_given?
        return doc
      end

      #
      # Creates a new `Nokogiri::XML::Builder`.
      #
      # @yield []
      #   The block that will be used to construct the XML document.
      #
      # @return [Nokogiri::XML::Builder]
      #   The new XML builder object.
      #
      # @example
      #   HTML.build do
      #     html {
      #       body {
      #         div(style: 'display:none;') {
      #           object(classid: 'blabla')
      #         }
      #       }
      #     }
      #   end
      #
      # @see http://rubydoc.info/gems/nokogiri/Nokogiri/XML/Builder
      #
      # @api public
      #
      def self.build(&block)
        Nokogiri::XML::Builder.new(&block)
      end
    end
  end
end
