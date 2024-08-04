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

require_relative '../command'

require 'ronin/core/cli/logging'
require 'ronin/web/server'

module Ronin
  module Web
    class CLI
      module Commands
        #
        # Starts a web server.
        #
        # ## Usage
        #
        #     ronin-web server [options]
        #
        # ## Options
        #
        #    -H, --host HOST                  Host name or IP to bind to (Default: localhost)
        #    -p, --port PORT                  Port number to listen on (Default: 8000)
        #    -A, --basic-auth USER:PASSWORD   Sets up Basic-Authentication
        #    -d, --dir /PATH:DIR              Mounts a directory to the given PATH
        #    -f, --file /PATH:FILE            Mounts a file to the given PATH
        #    -r, --root DIR                   Root directory to serve
        #    -R, --redirect /PATH:URL         Registers a 302 Found redirect at the given PATH
        #    -h, --help                       Print help information
        #
        class Server < Command

          include Core::CLI::Logging

          class App < Ronin::Web::Server::Base
          end

          option :host, short: '-H',
                        value: {
                          type:    String,
                          usage:   'HOST',
                          default: 'localhost'
                        },
                        desc: 'Host name or IP to bind to' do |host|
                          App.bind = host
                        end

          option :port, short: '-p',
                        value: {
                          type:    Integer,
                          usage:   'PORT',
                          default: App.port
                        },
                        desc: 'Port number to listen on' do |port|
                          App.port = port
                        end

          option :basic_auth, short: '-A',
                              value: {
                                type: String,
                                usage: 'USER:PASSWORD'
                              },
                              desc: 'Sets up Basic-Authentication' do |str|
                                auth_user, auth_password = str.split(':',2)

                                App.basic_auth(auth_user,auth_password)
                              end

          option :dir, short: '-d',
                       value: {
                         type:  String,
                         usage: '/PATH:DIR'
                       },
                       desc: 'Mounts a directory to the given PATH' do |str|
                         url_path, dir = str.split(':',2)

                         App.directory(url_path,dir)
                       end

          option :file, short: '-f',
                        value: {
                          type: String,
                          usage: '/PATH:FILE'
                        },
                        desc: 'Mounts a file to the given PATH' do |str|
                          url_path, file = str.split(':',2)

                          App.file(url_path,file)
                        end

          option :root, short: '-r',
                        value: {
                          type: String,
                          usage: 'DIR'
                        },
                        desc: 'Root directory to serve'

          option :redirect, short: '-R',
                            value: {
                              type:  String,
                              usage: '/PATH:URL'
                            },
                            desc: 'Registers a 302 Found redirect at the given PATH' do |str|
                              route, url = str.split(':',2)

                              App.redirect(route,url)
                            end

          description 'Starts a web server'

          man_page 'ronin-web-server.1'

          #
          # Runs the `ronin-web server` command.
          #
          def run
            if options[:root]
              App.public_dir = options[:root]
            else
              App.any('*') do
                puts "#{request.request_method} #{request.path}"

                request.headers.each do |name,value|
                  puts "#{name}: #{value}"
                end

                puts request.body.read
              end
            end

            log_info "Starting web server listening on #{App.bind}:#{App.port} ..."
            begin
              App.run!
            rescue Errno::EADDRINUSE => error
              log_error(error.message)
              exit(1)
            end

            log_info "Shutting down ..."
          end

        end
      end
    end
  end
end
