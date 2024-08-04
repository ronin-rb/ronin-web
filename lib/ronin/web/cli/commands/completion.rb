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

require 'ronin/core/cli/completion_command'

require_relative '../../root'

module Ronin
  module Web
    class CLI
      module Commands
        #
        # Manages the shell completion rules for `ronin-web`.
        #
        # ## Usage
        #
        #     ronin-web completion [options]
        #
        # ## Options
        #
        #         --print                      Prints the shell completion file
        #         --install                    Installs the shell completion file
        #         --uninstall                  Uninstalls the shell completion file
        #     -h, --help                       Print help information
        #
        # ## Examples
        #
        #     ronin-web completion --print
        #     ronin-web completion --install
        #     ronin-web completion --uninstall
        #
        # @since 2.0.0
        #
        class Completion < Core::CLI::CompletionCommand

          completion_file File.join(ROOT,'data','completions','ronin-web')

          man_dir File.join(ROOT,'man')
          man_page 'ronin-web-completion.1'

          description 'Manages the shell completion rules for ronin-web'

        end
      end
    end
  end
end
