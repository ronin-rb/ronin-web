#
# ronin-web - A collection of useful web helper methods and commands.
#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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
    # HTML helper methods.
    #
    # @since 1.0.0
    #
    module HTML
      #
      # Parses the body of a document into a HTML document object.
      #
      # @param [String, IO] body
      #   The body of the document to parse.
      #
      # @yield [doc]
      #   If a block is given, it will be passed the newly created document
      #   object.
      #
      # @yieldparam [Nokogiri::HTML::Document] doc
      #   The new HTML document object.
      #
      # @return [Nokogiri::HTML::Document]
      #   The new HTML document object.
      #
      # @see http://rubydoc.info/gems/nokogiri/Nokogiri/HTML/Document
      #
      # @api public
      #
      def self.parse(html)
        doc = Nokogiri::HTML.parse(html)
        yield doc if block_given?
        return doc
      end

      #
      # Creates a new Nokogiri::HTML::Builder.
      #
      # @yield []
      #   The block that will be used to construct the HTML document.
      #
      # @return [Nokogiri::HTML::Builder]
      #   The new HTML builder object.
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
      # @see http://rubydoc.info/gems/nokogiri/Nokogiri/HTML/Builder
      #
      # @api public
      #
      def self.build(&block)
        Nokogiri::HTML::Builder.new(&block)
      end
    end
  end
end
