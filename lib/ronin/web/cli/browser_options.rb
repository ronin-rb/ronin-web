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

require 'ronin/web/browser'

module Ronin
  module Web
    class CLI
      #
      # Adds options for opening a browser.
      #
      # @since 2.0.0
      #
      module BrowserOptions
        #
        # Adds the browser options to the command including {BrowserOptions}.
        #
        # @param [Class<Command>] command
        #   The command including {BrowserOptions}.
        #
        def self.included(command)
          command.option :browser, short: '-B',
                                   value: {
                                     type: String,
                                     usage: 'NAME|PATH'
                                   },
                                   desc: 'The browser name or path to execute'

          command.option :width, short: '-W',
                                 value: {
                                   type:    Integer,
                                   default: 1024,
                                   usage:   'WIDTH'
                                 },
                                 desc: 'Sets the width of the browser viewport'

          command.option :height, short: '-H',
                                  value: {
                                    type:    Integer,
                                    default: 768,
                                    usage:   'HEIGHT'
                                  },
                                  desc: 'Sets the height of the browser viewport'
        end

        #
        # The browser agent.
        #
        # @return [Ronin::Web::Browser::Agent]
        #
        def browser
          @browser ||= Web::Browser.new(**browser_kwargs)
        end

        #
        # Keyword arguments for `Ronin::Web::Browser.new`.
        #
        # @return [Hash{Symbol => Object}]
        #   The keyword arguments.
        #
        def browser_kwargs
          kwargs = {
            window_size: [options[:width], options[:height]]
          }

          if options[:browser]
            kwargs[:browser_path] = options[:browser]
          end

          return kwargs
        end
      end
    end
  end
end
