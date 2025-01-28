# frozen_string_literal: true
#
# ronin-web - A collection of useful web helper methods and commands.
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require_relative '../command'

require 'ronin/support/network/http'
require 'nokogiri'

module Ronin
  module Web
    class CLI
      module Commands
        #
        # Performs XPath queries on a URL or XML file.
        #
        # ## Usage
        #
        #     ronin-web xml [options] {URL | FILE} [XPATH]
        #
        # ## Options
        #
        #     -X, --xpath XPATH                XPath query
        #     -t, --text                       Prints the inner-text
        #     -F, --first                      Only print the first match
        #     -h, --help                       Print help information
        #
        # ## Arguments
        #
        #     URL | FILE                       The URL or FILE to search
        #     XPATH                            The XPath query
        #
        # @since 2.0.0
        #
        class Xml < Command

          usage '[options] {URL | FILE} [XPATH]'

          option :xpath, short: '-X',
                         value: {
                           type:  String,
                           usage: 'XPATH'
                         },
                         desc:  'XPath query' do |xpath|
                           @query = xpath
                         end

          option :first, short: '-F',
                         desc: 'Only print the first match'

          option :text, short: '-t',
                        desc:  'Prints the elements inner text'

          argument :source, required: true,
                            usage: 'URL | FILE',
                            desc:  'The URL or FILE to search'

          argument :query, required: false,
                           usage: 'XPATH',
                           desc: 'The XPath query'

          description 'Performs XPath queries on a URL or HTML file'

          man_page 'ronin-web-xml.1'

          # The XPath expression.
          #
          # @return [String, nil]
          attr_reader :query

          #
          # Runs the `ronin-web xml` command.
          #
          # @param [String] source
          #   The `URL` or `FILE` argument.
          #
          # @param [String, nil] query
          #   The optional XPath argument.
          #
          def run(source,query=@query)
            unless query
              print_error "must specify --xpath or an XPath argument"
              exit(-1)
            end

            doc   = parse(read(source))
            nodes = if options[:first] then doc.at(query)
                    else                    doc.search(query)
                    end

            if options[:text]
              puts nodes.inner_text
            else
              puts nodes
            end
          end

          #
          # Reads a URI or file.
          #
          # @param [String] source
          #   The URI or file path.
          #
          # @return [File, String]
          #   The contents of the URI or file.
          #
          def read(source)
            if source.start_with?('https://') ||
               source.start_with?('http://')
              Support::Network::HTTP.get_body(source)
            else
              File.new(source)
            end
          end

          #
          # Parses the HTML source code.
          #
          # @param [String] html
          #   The raw unparsed XML.
          #
          # @return [Nokogiri::XML::Document]
          #   The parsed XML document.
          #
          def parse(html)
            Nokogiri::XML(html)
          end

        end
      end
    end
  end
end
