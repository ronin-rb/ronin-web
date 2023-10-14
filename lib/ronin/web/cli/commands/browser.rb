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
require 'ronin/web/cli/browser_shell'
require 'ronin/web/cli/js_shell'

require 'command_kit/colors'

module Ronin
  module Web
    class CLI
      module Commands
        #
        # Screenshots one or more URLs.
        #
        # ## Usage
        #
        #     ronin-web browser [options] [URL]
        #
        # ## Options
        #
        #     -B, --browser NAME|PATH          The browser name or path to execute
        #     -W, --width WIDTH                Sets the width of the browser viewport (Default: 1024)
        #     -H, --height HEIGHT              Sets the height of the browser viewport (Default: 768)
        #         --headless                   Run the browser in headless mode
        #         --visible                    Open a visible browser
        #     -x, --x INT                      Sets the position of the browser X coordinate
        #     -y, --y INT                      Sets the position of the browser Y coordinate
        #         --inject-js JS               Injects JavaScript into every page
        #         --inject-js-file FILE        Injects a JavaScript file into every page
        #         --bypass-csp                 Enables bypassing CSP
        #         --print-urls                 Print all requested URLs
        #         --print-status               Print the status of all requested URLs
        #         --print-requests             Print all requests sent by the browser
        #         --print-responses            Print responses to all requests
        #         --print-traffic              Print requests and responses
        #         --print-headers              Print headers of requests/responses
        #         --print-body                 Print request/response bodies
        #         --shell                      Starts an interactive shell
        #         --js-shell                   Starts an interactive JavaScript shell
        #     -h, --help                       Print help information
        #
        # ## Arguments
        #
        #     [URL]                            The initial URL to visit
        #
        # @since 2.0.0
        #
        class Browser < Command

          include BrowserOptions
          include CommandKit::Colors

          usage '[options] [URL]'

          option :headless, desc: 'Run the browser in headless mode' do
            @mode = :headless
          end

          option :visible, desc: 'Open a visible browser' do
            @mode = :visible
          end

          option :x, short: '-x',
                     value: {
                       type: Integer
                     },
                     desc: "Sets the position of the browser X coordinate"

          option :y, short: '-y',
                     value: {
                       type: Integer
                     },
                     desc: "Sets the position of the browser Y coordinate"

          option :inject_js, value: {
                               type: String,
                               usage: 'JS'
                             },
                             desc: 'Injects JavaScript into every page'

          option :inject_js_file, value: {
                                    type: String,
                                    usage: 'FILE'
                                  },
                                  desc: 'Injects a JavaScript file into every page'

          option :bypass_csp, desc: 'Enables bypassing CSP'

          option :print_urls, desc: 'Print all requested URLs'

          option :print_status, desc: 'Print the status of all requested URLs'

          option :print_requests, desc: 'Print all requests sent by the browser'

          option :print_responses, desc: 'Print responses to all requests'

          option :print_traffic, desc: 'Print requests and responses'

          option :print_headers, desc: 'Print headers of requests/responses'

          option :print_cookies, desc: 'Print Set-Cookie headers from all responses'

          option :print_body, desc: 'Print request/response bodies'

          option :shell, desc: 'Starts an interactive shell'

          option :js_shell, desc: 'Starts an interactive JavaScript shell'

          argument :url, required: false,
                         desc:     'The initial URL to visit'

          description "Automates a web browser"

          man_page 'ronin-web-browser.1'

          #
          # Initializes the `ronin-web browser` command.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keywords for the command.
          #
          def initialize(**kwargs)
            super(**kwargs)

            @mode = if stdout.tty? then :visible
                    else                :headless
                    end
          end

          #
          # Runs the `ronin-web browser` command.
          #
          # @param [String, nil] url
          #   The optional URL to visit.
          #
          def run(url=nil)
            unless (url || options[:shell] || options[:js_shell])
              print_error "must specify a URL or --shell / --js-shell"
              exit(-1)
            end

            configure_browser
            open_browser(url)

            if options[:shell] || options[:js_shell]
              start_shell
            else
              wait_until_closed
            end

            close_browser
          end

          #
          # Configures the browser and registers callbacks.
          #
          def configure_browser
            if options[:x] || options[:y]
              browser.position = {
                left: options.fetch(:x,0),
                top:  options.fetch(:y,0)
              }
            end

            browser.bypass_csp = true if options[:bypass_csp]

            if options[:inject_js_file]
              browser.inject_js(File.read(options[:inject_js_file]))
            elsif options[:inject_js]
              browser.inject_js(options[:inject_js])
            end

            if options[:print_status]
              browser.every_response(&method(:print_url_status))
            elsif options[:print_cookies]
              browser.every_response(&method(:print_cookies))
            elsif options[:print_urls]
              browser.every_url(&method(:puts))
            elsif options[:print_traffic]
              browser.every_request(&method(:print_request))
              browser.every_response(&method(:print_response))
            else
              browser.every_request(&method(:print_request))   if options[:print_requests]
              browser.every_response(&method(:print_response)) if options[:print_responses]
            end
          end

          #
          # Open the browser window.
          #
          # @param [String, nil] url
          #   The optional URL to visit.
          #
          def open_browser(url=nil)
            browser.goto(url) if url
          end

          #
          # Starts an interactive browser shell.
          #
          def start_shell
            # start the shell then immediately quit the browser once exited
            if options[:js_shell]
              JSShell.start(browser)
            elsif options[:shell]
              BrowserShell.start(browser)
            end
          end

          #
          # Waits until the browser is done or if the user exits the command.
          #
          def wait_until_closed
            if @mode == :visible
              # wait for the browser window to be closed
              browser.wait_until_closed
            else
              # wait until there's no network traffic
              browser.network.wait_for_idle { browser.quit }
            end
          end

          #
          # Close the browser.
          #
          def close_browser
            browser.quit
          end

          #
          # Additional keyword arguments for `Ronin::Web::Browser.new`.
          #
          # @return [Hash{Symbol => Object}]
          #
          def browser_kwargs
            kwargs = super()

            case @mode
            when :headless then kwargs[:headless] = true
            when :visible  then kwargs[:visible]  = true
            end

            return kwargs
          end

          #
          # Prints the status and URL of a response.
          #
          # @param [Ferrum::Network::Response] response
          #   The respones object.
          #
          def print_url_status(response)
            if response.status < 300
              puts "#{colors.bright_green(response.status)} #{colors.green(response.url)}"
            elsif response.status < 400
              puts "#{colors.bright_yellow(response.status)} #{colors.yellow(response.url)}"
            elsif response.status < 500
              puts "#{colors.bright_red(response.status)} #{colors.red(response.url)}"
            else
              puts "#{colors.bold(colors.bright_red(response.status))} #{colors.bold(colors.red(response.url))}"
            end
          end

          #
          # Prints a request from the browser.
          #
          # @param [Ferrum::Network::InterceptedRequest] request
          #
          def print_request(request)
            sigil = colors.bold(colors.bright_white('>'))

            puts "#{sigil} #{colors.bold(colors.bright_cyan(request.method))} #{colors.cyan(request.url)}"

            if options[:print_headers]
              print_headers(sigil,request.headers)
            end

            if options[:print_body] && (body = request.body)
              print_body(sigil,body)
            end
          end

          #
          # Prints a response.
          #
          # @param [Ferrum::Network::Response] response
          #   The respones object.
          #
          def print_response(response)
            sigil = colors.bold(colors.bright_white('<'))

            print "#{sigil} "
            print_url_status(response)

            if options[:print_headers]
              print_headers(sigil,response.headers)
            end

            if options[:print_body]
              print_body(sigil,response.body)
            end
          end

          #
          # Prints headers.
          #
          # @param [String] sigil
          #   The "sigil" representing either a request (`>`) or
          #   a response (`<`).
          #
          # @param [Hash{String => String}] headers
          #   The header names and values.
          #
          def print_headers(sigil,headers)
            headers.each do |name,value|
              puts "#{sigil} #{colors.bright_white(name)}: #{value}"
            end
          end

          #
          # Prints the request or response body.
          #
          # @param [String] sigil
          #   The "sigil" representing either a request (`>`) or
          #   a response (`<`).
          #
          # @param [String] body
          #   the request or response body.
          #
          def print_body(sigil,body)
            puts sigil
            response.body.each_line do |line|
              puts "#{sigil} #{line}"
            end
          end

          #
          # Prints the `Set-Cookie` header for each HTTP response.
          #
          # @param [Ferrum::Network::Response] response
          #   A response from the browser.
          #
          def print_cookies(response)
            if (set_cookie = respones.headers['set-cookie'])
              puts set_cookie
            end
          end

        end
      end
    end
  end
end
