# frozen_string_literal: true
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

require 'ronin/web/cli/command'
require 'ronin/web/root'

require 'ronin/core/cli/generator'

module Ronin
  module Web
    class CLI
      module Commands
        class New < Command
          #
          # Generate a new ronin-web-server based web app.
          #
          # ## Usage
          #
          #     ronin-web new app [options] DIR
          #
          # ## Options
          #
          #         --port PORT                  The port the webpp will listen on by default (Default: 3000)
          #         --ruby-version VERSION       The desired ruby version for the project (Default: 3.1.3)
          #         --git                        Initializes a git repo
          #     -D, --dockerfile                 Adds a Dockerfile to the new project
          #     -h, --help                       Print help information
          #
          # ## Arguments
          #
          #     DIR                              The directory to create
          #
          class App < Command

            include Core::CLI::Generator

            template_dir File.join(ROOT,'data','new','app')

            usage '[options] DIR'

            option :port, value: {
                            type:    Integer,
                            usage:   'PORT',
                            default: 3000
                          },
                          desc: 'The port the webpp will listen on by default'

            option :ruby_version, value: {
                                    type:    String,
                                    usage:   'VERSION',
                                    default: RUBY_VERSION
                                  },
                                  desc: 'The desired ruby version for the project'

            option :git, desc: 'Initializes a git repo'

            option :dockerfile, short: '-D',
                                desc: 'Adds a Dockerfile to the new project'

            argument :dir, required: true,
                           desc: 'The directory to create'

            description 'Generate a new ronin-web-server based app'

            man_page 'ronin-web-new-app.1'

            #
            # Runs the `ronin-web new app` command.
            #
            # @param [String] path
            #   The path to the new project directory to create.
            #
            def run(path)
              @ruby_version = options[:ruby_version]
              @port         = options[:port]

              mkdir path
              mkdir File.join(path,'lib')
              mkdir File.join(path,'views')
              mkdir File.join(path,'public')

              erb '.ruby-version.erb', File.join(path,'.ruby-version')
              cp 'Gemfile', path
              erb 'app.rb.erb', File.join(path,'app.rb')
              cp 'config.ru', path

              if options[:dockerfile]
                erb 'Dockerfile.erb', File.join(path,'Dockerfile')
                erb 'docker-compose.yml.erb', File.join(path,'docker-compose.yml')
              end

              if options[:git]
                cp '.gitignore', path

                Dir.chdir(path) do
                  sh 'git', 'init', '-q', '-b', 'main'
                  sh 'git', 'add', '.'
                  sh 'git', 'commit', '-q', '-m', 'Initial commit.'
                end
              end
            end

          end
        end
      end
    end
  end
end
