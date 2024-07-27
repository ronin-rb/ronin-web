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

require 'ronin/support/web'
require 'ronin/web/browser'
require 'ronin/web/server'
require 'ronin/web/session_cookie'
require 'ronin/web/spider'
require 'ronin/web/user_agents'
require 'ronin/web/version'

require 'open_namespace'

module Ronin
  #
  # Top-level namespace for `ronin-web`.
  #
  module Web
    include OpenNamespace
    include Support::Web
    include Browser::Mixin
  end
end
