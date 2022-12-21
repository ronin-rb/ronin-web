# frozen_string_literal: true
#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-web.
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
require 'ronin/web/root'

require 'ronin/core/cli/generator'

module Ronin
  module Web
    class CLI
      module Commands
        class New < Command
          #
          # Creates a new [ronin-web-server] script.
          #
          # [ronin-web-server]: https://github.com/ronin-rb/ronin-web-server#readme
          #
          # ## Usage
          #
          #     ronin-web server [options]
          #
          # ## Options
          #
          #     -H, --host HOST|IP               Optional host or IP interface to listen on. Defaults to 0.0.0.0.
          #     -p, --port PORT                  Optional port to listen on. Defaults to 8000.
          #     -h, --help                       Print help information
          #
          # ## Arguments
          #
          #     FILE                             The file to create
          #
          class Server < Command

            include Core::CLI::Generator

            template_dir File.join(ROOT,'data','new')

            usage '[options] FILE'

            option :host, short: '-H',
                          value: {
                            type:  String,
                            usage: 'HOST|IP'
                          },
                          desc: 'Optional host or IP interface to listen on. Defaults to 0.0.0.0.'

            option :port, short: '-p',
                          value: {
                            type:  Integer,
                            usage: 'PORT'
                          },
                          desc: 'Optional port to listen on. Defaults to 8000.'

            argument :file, required: true,
                            desc: 'The file to create'

            description 'Creates a new web server script'

            man_page 'ronin-web-new-server.1'

            #
            # Runs the `ronin-web new server` command.
            #
            # @param [String] path
            #   The path to the new script file to create.
            #
            def run(path)
              @host = options[:host]
              @port = options[:port]

              erb 'server.rb.erb', path
              chmod '+x', path
            end

          end
        end
      end
    end
  end
end
