# frozen_string_literal: true
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

require 'ronin/web/cli/command'
require 'command_kit/commands/auto_load'

module Ronin
  module Web
    class CLI
      module Commands
        #
        # Creates new projects or scripts.
        #
        # ## Usage
        #
        #     ronin-web new {nokogiri | server | spider | webapp}
        #
        # ## Options
        #
        #     -h, --help                       Print help information
        #
        # ## Arguments
        #
        #
        #     [COMMAND]                        The command name to run
        #     [ARGS ...]                       Additional arguments for the command
        #
        # ## Commands
        #
        #     help
        #     nokogiri
        #     server
        #     spider
        #     webapp
        #
        class New < Command

          include CommandKit::Commands::AutoLoad.new(
            dir:       "#{__dir__}/new",
            namespace: "#{self}"
          )

          man_page 'ronin-web-new.1'

        end
      end
    end
  end
end
