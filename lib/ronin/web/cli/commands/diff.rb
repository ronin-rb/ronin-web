# frozen_string_literal: true
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

require 'ronin/web/cli/command'
require 'ronin/support/network/http'

require 'command_kit/terminal'
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

          include CommandKit::Terminal

          usage '[options] {URL | FILE} {URL | FILE}'

          argument :page1, required: true,
                           usage:    'URL | FILE',
                           desc:     'The original URL or file'

          argument :page2, required: true,
                           usage:    'URL | FILE',
                           desc:     'The modified URL or file'

          option :format, short: '-f', value: {
            type: String,
            default: 'html',
            usage: 'html | xml'
          },
          desc: 'The format of the web pages'

          description 'Diffs two web pges'

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
            doc1, doc2 = load_doc(page1, page2)

            doc1.diff(doc2) do |change,node|
              unless change == ' '
                puts "#{change} #{node}"
              end
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

          private

          def load_doc(page1, page2)
            case options[:format].to_sym
            when :html
              [load_html(page1), load_html(page2)]
            when :xml
              [load_xml(page1), load_xml(page2)]
            else
              raise "Unsupported format"
            end
          end

          def load_html(page)
            Nokogiri::HTML(read(page))
          end

          def load_xml(page)
            Nokogiri::XML(read(page))
          end

        end
      end
    end
  end
end
