# frozen_string_literal: true
#
# ronin-web - A collection of useful web helper methods and commands.
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/core/cli/shell'

module Ronin
  module Web
    class CLI
      #
      # Represents a JavaScript shell for a browser.
      #
      class JSShell < Core::CLI::Shell

        shell_name 'js'

        # The parent browser.
        #
        # @return [Ronin::Web::Browser::Agent]
        attr_reader :browser

        #
        # Initializes the JavaScript shell.
        #
        # @param [Ronin::Web::Browser::Agent] browser
        #   The browser instance.
        #
        def initialize(browser,**kwargs)
          super(**kwargs)

          @browser = browser
        end

        #
        # Evaluates the JavaScript in the current browser page.
        #
        # @param [String] js
        #   The JavaScript to evaluate.
        #
        def exec(js)
          value = @browser.eval_js(js)

          unless value.nil?
            p value
          end
        rescue Ferrum::JavaScriptError => error
          puts error.message
        end

      end
    end
  end
end
