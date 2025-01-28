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

require 'ronin/core/cli/ruby_shell'

module Ronin
  module Web
    class CLI
      #
      # The interactive Ruby shell for {Ronin::Web}.
      #
      class RubyShell < Core::CLI::RubyShell

        #
        # Initializes the `ronin-web` Ruby shell.
        #
        # @param [String] name
        #   The name of the IRB shell.
        #
        # @param [Object] context
        #   Custom context to launch IRB from within.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for
        #   `Ronin::Core::CLI::RubyShell#initialize`.
        #
        def initialize(name: 'ronin-web', context: Web, **kwargs)
          super(name: name, context: context, **kwargs)
        end

      end
    end
  end
end
