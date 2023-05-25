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
require 'ronin/web/cli/browser_options'

require 'ronin/core/cli/logging'

module Ronin
  module Web
    class CLI
      module Commands
        #
        # Screenshots one or more URLs.
        #
        # ## Usage
        #
        #     ronin-web screenshot [options] {URL [...] | --file FILE}
        #
        # ## Options
        #
        #     -B, --browser NAME|PATH          The browser name or path to execute
        #     -W, --browser-width WIDTH        Sets the width of the browser viewport (Default: 1024)
        #     -H, --browser-height HEIGHT      Sets the height of the browser viewport (Default: 768)
        #     -f, --file FILE                  Input file to read URLs from
        #     -F, --format png|jpg             Screenshot image format (Default: png)
        #     -d, --directory DIR              Directory to save images to (Default: /data/home/postmodern/code/ronin-rb/ronin-web)
        #         --full                       Screenshots the full page
        #     -C, --css-path CSSPath           The CSSpath selector to screenshot
        #     -h, --help                       Print help information
        #
        # ## Arguments
        #
        #     URL ...                          The URL visit and screenshot
        #
        class Screenshot < Command

          include Core::CLI::Logging
          include BrowserOptions

          usage '[options] {URL [...] | --file FILE}'

          option :file, short: '-f',
                        value: {
                          type: String,
                          usage: 'FILE'
                        },
                        desc: 'Input file to read URLs from'

          option :format, short: '-F',
                          value: {
                            type:    [:png, :jpg],
                            default: :png
                          },
                          desc: 'Screenshot image format'

          option :directory, short: '-d',
                             value: {
                               type:    String,
                               usage:   'DIR',
                               default: Dir.pwd
                             },
                             desc: 'Directory to save images to'

          option :full, desc: 'Screenshots the full page'

          option :css_path, short: '-C',
                            value: {
                              type:  String,
                              usage: 'CSSPath'
                            },
                            desc: 'The CSSpath selector to screenshot'

          argument :url, required: true,
                         repeats:  true,
                         desc:     'The URL visit and screenshot'

          description 'Screenshots one or more URLs'

          man_page 'ronin-web-screenshot.1'

          #
          # Runs the `ronin-web screenshot` command.
          #
          # @param [Array<String>] urls
          #   The URLs to screenshot.
          #
          def run(*urls)
            if options[:file]
              File.open(options[:file]) do |file|
                file.each_line(chomp: true) do |url|
                  process_url(url)
                end
              end
            elsif !urls.empty?
              urls.each do |url|
                process_url(url)
              end
            else
              print_error "must specify --file or URL arguments"
              exit(-1)
            end
          end

          #
          # Visits and screenshots a URL.
          #
          # @param [String] url
          #   The URL to screenshot.
          #
          def process_url(url)
            begin
              browser.goto(url)
            rescue Ferrum::StatusError
              print_error "failed to request URL: #{url}"
            end

            image_path = image_path_for(url)
            FileUtils.mkdir_p(File.dirname(image_path))

            log_info "Screenshotting #{url} to #{image_path} ..."
            browser.screenshot(
              path:     image_path,
              format:   options[:format],
              full:     options[:full],
              selector: options[:css_path]
            )
          end

          #
          # Parses a URL.
          #
          # @param [String] url
          #   The URL string to parse.
          #
          # @return [URI::HTTP, URI::HTTPS]
          #   The parsed URL.
          #
          def parse_url(url)
            URI.parse(url)
          rescue URI::InvalidURI
            print_error "invalid URI: #{url}"
            exit(1)
          end

          #
          # Generates the image path for a given URL.
          #
          # @param [String] url
          #   The given URL.
          #
          # @return [String]
          #   The relative image path that represents the URL.
          #
          def image_path_for(url)
            uri = parse_url(url)

            path = File.join(options[:directory],uri.host,uri.request_uri)
            path << 'index' if path.end_with?('/')
            path << ".#{options[:format]}"

            return path
          end

        end
      end
    end
  end
end
