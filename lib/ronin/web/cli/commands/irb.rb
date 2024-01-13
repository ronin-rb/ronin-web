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

require 'ronin/web/cli/command'
require 'ronin/web/cli/ruby_shell'

module Ronin
  module Web
    class CLI
      module Commands
        #
        # Starts an interactive Ruby shell with `ronin-web` loaded.
        #
        # ## Usage
        #
        #     ronin-web irb [options]
        #
        # ## Options
        #
        #     -h, --help                       Print help information
        #
        class Irb < Command

          description "Starts an interactive Ruby shell with ronin-web loaded"

          man_page 'ronin-web-irb.1'

          #
          # Runs the `ronin-web irb` command.
          #
          def run
            require 'ronin/web'
            CLI::RubyShell.start
          end

        end
      end
    end
  end
end
