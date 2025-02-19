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
require 'command_kit/colors'
require 'nokogiri/diff'

module Ronin
  module Web
    class CLI
      module Commands
        #
        # Diffs two web pages.
        #
        # ## Usage
        #
        #     ronin-web diff [options] {URL | FILE} {URL | FILE}
        #
        # ## Arguments
        #
        #     URL | FILE                       The original URL or file
        #     URL | FILE                       The modified URL or file
        #
        # ## Options
        #
        #     -h, --help                       Print help information
        #     -f, --format                     Pass the format of the URL or files. Supported formats are html and xml. (Default: html)
        #
        class Diff < Command

          include CommandKit::Colors

          usage '[options] {URL | FILE} {URL | FILE}'

          argument :page1, required: true,
                           usage:    'URL | FILE',
                           desc:     'The original URL or file'

          argument :page2, required: true,
                           usage:    'URL | FILE',
                           desc:     'The modified URL or file'

          option :format, short: '-f',
                          value: {
                            type: [:html, :xml],
                            default: :html
                          },
                          desc: 'The format of the web pages'

          description 'Diffs two web pages'

          man_page 'ronin-web-diff.1'

          #
          # Runs the `ronin-web diff` command.
          #
          # @param [String] page1
          #   The URL or file path of the original page.
          #
          # @param [String] page2
          #   The URL or file path of the modified page.
          #
          def run(page1,page2)
            doc1 = parse_doc(page1)
            doc2 = parse_doc(page2)

            doc1.diff(doc2) do |change,node|
              unless change == ' ' # ignroe unchanged nodes
                print_change(change,node)
              end
            end
          end

          #
          # Prints a change to the document.
          #
          # @param ["+", "-"] change
          #   The type of change.
          #
          #   * `+` - indicates an added node.
          #   * `-` - indicates a removed node.
          #
          # @param [Nokogiri::HTML::Node, Nokogiri::HTML::Node] node
          #   The node that was changed.
          #
          def print_change(change,node)
            color = case change
                    when '+' then colors.method(:green)
                    when '-' then colors.method(:red)
                    end

            content = node.to_s

            content.each_line(chomp: true) do |line|
              puts color.call("#{change} #{line}")
            end
          end

          #
          # Reads a web page.
          #
          # @param [String] source
          #   The URL or file path of the web page.
          #
          # @return [String, File]
          #   The contents of the web page.
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
          # Loads the given html or xml sources
          #
          # @param [String] page
          #   The URL or file path of the original page.
          #
          # @return [Nokogiri::HTML::Document, Nokogiri::XML::Document]
          #   html or xml document depends upon --format option
          #
          def parse_doc(page)
            case options[:format]
            when :html
              Nokogiri::HTML(read(page))
            when :xml
              Nokogiri::XML(read(page))
            else
              raise(NotImplementedError,"unsupported format: #{options[:format].inspect}")
            end
          end
        end
      end
    end
  end
end
