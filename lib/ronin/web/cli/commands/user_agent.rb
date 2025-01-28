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

require_relative '../command'

require 'ronin/web/user_agents'

module Ronin
  module Web
    class CLI
      module Commands
        #
        # Generates a random HTTP `User-Agent` string.
        #
        # ## Usage
        #
        #     ronin-web user_agent [options]
        #
        # ## Options
        #
        #     -B, --browser chrome|firefox     The desired browser
        #         --chrome-version VERSION     The desired Chrome version
        #         --firefox-version VERSION    The desired Firefox version
        #     -D ubuntu|fedora|arch|DISTRO,    The desired Linux distro
        #         --linux-distro
        #     -A x86-64|x86|i686|aarch64|arm64|arm,
        #         --arch                       The desired architecture
        #     -O, --os android|linux|windows   The desired OS
        #         --os-version VERSION         The desired OS version
        #     -h, --help                       Print help information
        #
        # @since 2.0.0
        #
        class UserAgent < Command

          usage '[options]'

          option :browser, short: '-B',
                           value: {
                             type: [:chrome, :firefox]
                           },
                           desc: 'The desired browser'

          option :chrome_version, value: {
                                    type:  String,
                                    usage: 'VERSION'
                                  },
                                  desc: 'The desired Chrome version'

          option :firefox_version, value: {
                                     type:  String,
                                     usage: 'VERSION'
                                   },
                                   desc: 'The desired Firefox version'

          option :linux_distro, short: '-D',
                                value: {
                                  type:  String,
                                  usage: 'ubuntu|fedora|arch|DISTRO'
                                },
                                desc: 'The desired Linux distro' do |distro|
                                  options[:linux_distro] = case distro
                                                           when 'ubuntu'
                                                             :ubuntu
                                                           when 'fedora'
                                                             :fedora
                                                           when 'arch'
                                                             :arch
                                                           else
                                                             distro
                                                           end
                                end

          option :arch, short: '-A',
                        value: {
                          type: {
                            'x86-64'  => :x86_64,
                            'x86'     => :x86,
                            'i686'    => :i686,
                            'aarch64' => :aarch64,
                            'arm64'   => :arm64,
                            'arm'     => :arm
                          }
                        },
                        desc: 'The desired architecture'

          option :os, short: '-O',
                      value: {
                        type: [:android, :linux, :windows]
                      },
                      desc: 'The desired OS'

          option :os_version, value: {
                                type:  String,
                                usage: 'VERSION'
                              },
                              desc: 'The desired OS version'

          description 'Generates a random User-Agent string'

          man_page 'ronin-web-user-agent.1'

          #
          # Runs the `ronin-web user-agent` command.
          #
          def run
            case options[:browser]
            when :chrome
              puts Web::UserAgents.chrome.random(**random_kwargs)
            when :firefox
              puts Web::UserAgents.firefox.random(**random_kwargs)
            when nil
              puts Web::UserAgents.random(**random_kwargs)
            else
              raise(NotImplementedError,"unsupported browser type: #{options[:browser].inspect}")
            end
          end

          #
          # Generates keyword arguments for `Ronin::Web::UserAgents.random`,
          # `Ronin::Web::UserAgents.chrome.random`, or
          # `Ronin::Web::UserAgents.firefox.random`.
          #
          # @return [Hash{Symbol => Object}]
          #   The keyword arguments for the User-Agent module's `random` method.
          #
          def random_kwargs
            kwargs = {}

            if options[:chrome_version] && options[:browser] == :chrome
              kwargs[:chrome_version] = options[:chrome_version]
            end

            if options[:firefox_version] && options[:browser] == :firefox
              kwargs[:firefox_version] = options[:firefox_version]
            end

            if options[:os]
              kwargs[:os] = options[:os]
            end

            if options[:os_version]
              kwargs[:os_version] = options[:os_version]
            end

            if options[:linux_distro]
              kwargs[:linux_distro] = options[:linux_distro]
            end

            if options[:arch]
              kwargs[:arch] = options[:arch]
            end

            return kwargs
          end

        end
      end
    end
  end
end
