#
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-web.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/ui/output/helpers'

require 'sinatra/base'
require 'rack/utils'

module Ronin
  module Web
    module Server
      #
      # Provides Sinatra routing and helper methods.
      #
      module Helpers

        include Rack::Utils
        include Sinatra::Helpers
        include UI::Output::Helpers

        alias h escape_html
        alias file send_file

        #
        # Returns the MIME type for a path.
        #
        # @param [String] path
        #   The path to determine the MIME type for.
        #
        # @return [String]
        #   The MIME type for the path.
        #
        # @since 0.3.0
        #
        # @api public
        #
        def mime_type_for(path)
          mime_type(File.extname(path))
        end

        #
        # Sets the `Content-Type` for the file.
        #
        # @param [String] path
        #   The path to determine the `Content-Type` for.
        #
        # @since 0.3.0
        #
        # @api public
        #
        def content_type_for(path)
          content_type mime_type_for(path)
        end
      end
    end
  end
end
