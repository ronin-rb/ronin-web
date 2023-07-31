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

require 'ronin/core/cli/command_shell'
require 'ronin/web/cli/js_shell'
require 'ronin/web/browser'

module Ronin
  module Web
    class CLI
      #
      # The interactive browser shell used by the `ronin-web browser --shell`
      # command.
      #
      class BrowserShell < Core::CLI::CommandShell

        shell_name 'browser'

        # The browser instance.
        #
        # @return [Ronin::Web::Browser::Agent]
        attr_reader :browser

        #
        # Initializes the browser shell.
        #
        # @param [Ronin::Web::Browser::Agent] browser
        #   The browser instance.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for the shell.
        #
        def initialize(browser,**kwargs)
          super(**kwargs)

          @browser = browser
        end

        command :goto, usage:   'URL',
                       summary: 'Visits a URL'

        #
        # The `goto` command.
        #
        # @param [String] url
        #   The URL to visit.
        #
        def goto(url)
          @browser.goto(url)
        end

        command :back, summary: 'Goes to the previous URL'

        #
        # The `back` command.
        #
        def back
          @browser.back
        end

        command :foreward, summary: 'Goes to the next URL'

        #
        # The `foreward` command.
        #
        def foreward
          @browser.foreward
        end

        command :foreward, summary: 'Refreshes the browser window'

        #
        # The `refresh` command.
        #
        def refresh
          @browser.refresh
        end

        command :pos, usage: 'X Y',
                      summary: "Set the browser window's position"

        #
        # The `pos` command.
        #
        # @param [String] x
        #   The X coordinate.
        #
        # @param [String] y
        #   The Y coordinate.
        #
        def pos(x,y)
          @browser.position = {left: x.to_i, top: y.to_i}
        end

        command :xpath, usage:   'XPATH',
                        summary: "Queries the browser's DOM using the XPath"

        #
        # The `xpath` command.
        #
        # @param [String] xpath
        #   The XPath expression.
        #
        def xpath(xpath)
          puts @browser.xpath(xpath)
        end

        command :at_xpath, usage:   'XPATH',
                           summary: "Queries the browser's DOM using the XPath"

        #
        # The `at_xpath` command.
        #
        # @param [String] xpath
        #   The XPath expression.
        #
        def at_xpath(xpath)
          puts @browser.at_xpath(xpath)
        end

        command :css, usage:   'CSSPath',
                      summary: "Queries the browser's DOM using the CSSPath"

        #
        # The `css` path command.
        #
        # @param [String] css_path
        #   The CSS path expression.
        #
        def css(css_path)
          puts @browser.css(css_path)
        end

        command :at_css, usage:   'CSSPath',
                         summary: "Queries the browser's DOM using the CSSPath"

        #
        # The `at_css` command.
        #
        # @param [String] css_path
        #   The CSS path expression.
        #
        def at_css(css_path)
          puts @browser.at_css(css_path)
        end

        command :eval_js, usage:   'JAVASCRIPT',
                          summary: "Evaluates some JavaScript in the browser's window"

        #
        # The `eval_js` command.
        #
        # @param [String] javascript
        #   The JavaScript source code to inject.
        #
        def eval_js(javascript)
          p @browser.eval_js(javascript)
        end

        command :inject_js, usage:   'JAVASCRIPT',
                            summary: 'Injects JavaScript into each new page'

        #
        # The `inject_js` command.
        #
        # @param [String] javascript
        #   The JavaScript source code to inject.
        #
        def inject_js(javascript)
          @browser.evaluate_on_new_document(javascript)
        end

        command :load_js, usage: 'URL|JS',
                          summary: 'Adds a <script> tag to the page'

        #
        # The `load_js` command.
        #
        # @param [String] url_or_js
        #   The URL or JavaScript code to load.
        #
        def load_js(url_or_js)
          if url_or_js.start_with('http://') ||
             url_or_js.start_with('https://')
            @browser.load_js(url: url_or_js)
          else
            @browser.load_js(content: url_or_js)
          end
        end

        command :js, summary: 'Starts an interactive JavaScript sub-shell'

        #
        # The `js` command.
        #
        def js
          JSShell.start(@browser)
        end

        command :load_css, usage:   'URL|CSS',
                           summary: 'Adds a <style> tag to the page'

        #
        # The `load_css` command.
        #
        # @param [String] url_or_css
        #   The URL or CSS code to load.
        #
        def load_css(url_or_css)
          if url_or_css.start_with('http://') ||
             url_or_css.start_with('https://')
            @browser.load_css(url: url_or_css)
          else
            @browser.load_css(content: url_or_css)
          end
        end

        command :bypass_csp, summary: 'Enables bypassing Content-Security-Policy (CSP)'

        #
        # The `bypass_csp` command.
        #
        def bypass_csp
          @browser.bypass_csp = true
        end

        command :url, summary: "Prints the browser's current URL"

        #
        # The `url` command.
        #
        def url
          puts @browser.current_url
        end

        command :body, summary: "Print's the page body"

        #
        # The `body` command.
        #
        def body
          puts @browser.body
        end

        command :screenshot, usage:   'PATH',
                             summary: 'Takes a screenshot of the page'

        #
        # The `screenshot` command.
        #
        # @param [String] path
        #   The output path.
        #
        def screenshot(path)
          @browser.screenshot(path: path)
        end

        command :pdf, usage: 'PATH',
                      summary: 'Convert the page into a PDF'

        #
        # The `pdf` command.
        #
        # @param [String] path
        #   The output path.
        #
        def pdf(path)
          @browser.pdf(path: path)
        end

        command :mhtml, usage:   'PATH',
                        summary: 'Save the current page as MHTML'

        #
        # The `mhtml` command.
        #
        def mhtml(path)
          @browser.mhtml(path: path)
        end

        command :reset, summary: 'Resets the browser'

        #
        # The `reset` command.
        #
        def reset
          @browser.reset
        end

        command :requests, summary: 'Display all requests'

        #
        # The `requests` command.
        #
        def requests
          puts @browser.network.traffic
        end

        command :wait, summary: 'Waits until all network requests have been completed'

        #
        # The `wait` command.
        #
        def wait
          @browser.wait_for_idle
        end

        command :clear_cache, summary: "Clears the browser's cache"

        #
        # The `clear_cache` command.
        #
        def clear_cache
          @browser.clear(:cache)
        end

        command :basic_auth, usage:   'USER PASSWORD',
                             summary: 'Configures Basic-Auth credentials'

        #
        # The `basic_auth` command.
        #
        # @param [String] user
        #   The user name.
        #
        # @param [String] password
        #   The password.
        #
        def basic_auth(user,password)
          @browser.network.authorize(user: user, password: password, &:continue)
        end

        command :cookies, summary: 'Prints all cookies'

        #
        # The `cookies` command.
        #
        def cookies
          print_cookies(@browser.cookies)
        end

        command :session_cookies, summary: 'Print all session cookies'

        #
        # The `session_cookies` command.
        #
        def session_cookies
          print_cookies(@browser.each_session_cookie)
        end

        command :set_cookie, usage: 'NAME=VALUE; [flags...]',
                             summary: 'Sets a cookie in the browser'

        #
        # The `set_cookie` command.
        #
        # @param [Array<String>] args
        #
        def set_cookie(*args)
          if args.empty?
            print_error "must specify at least a NAME=VALUE"
            return false
          end

          cookie = Web::Browser::Cookie.parse(args.join(' '))

          @browser.cookies.set(cookie)
        end

        command :load_cookies, usage: 'FILE',
                               summary: 'Loads cookies from the file into the browser'

        #
        # The `load_cookies` command.
        #
        # @param [String] path
        #   The path to the cookies file.
        #
        def load_cookies(path)
          unless File.file?(path)
            print_error "no such file or directory: #{path}"
            return false
          end

          @browser.load_cookies(path)
        end

        command :save_cookies, usage:   'FILE',
                               summary: "Saves the browser's cookies to the file"

        #
        # The `save_cookies` command.
        #
        # @param [String] path
        #   The path to the cookies file.
        #
        def save_cookies(path)
          @browser.save_cookies(path)
        end

        private

        #
        # Prints cookies grouped by `Domain` and `Path`.
        #
        # @param [Enumerator<Ferrum::Cookies::Cookie>] cookies
        #   The cookies to print.
        #
        def print_cookies(cookies)
          cookies_by_domain = cookies.group_by(&:domain)

          cookies_by_domain.each do |domain,domain_cookies|
            puts domain

            cookies_by_path = domain_cookies.group_by(&:path)

            cookies_by_path.each do |path,path_cookies|
              puts "  #{path}"

              path_cookies.each do |cookie|
                puts "    #{cookie.name}=#{cookie.value}"
              end
            end
            puts
          end
        end

      end
    end
  end
end
