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
require 'ronin/web/session_cookie'
require 'ronin/support/network/http'
require 'ronin/support/encoding/hex'

require 'command_kit/options/verbose'
require 'command_kit/printing/indent'

module Ronin
  module Web
    class CLI
      module Commands
        #
        # Parses and deserializes various session cookie formats.
        #
        # ## Usage
        #
        #     ronin-web session_cookie [options] {URL | COOKIE}
        #
        # ## Options
        #
        #     -v, --verbose                    Enables verbose output
        #     -F, --format ruby|json|yaml      The format to print the session cookie params (Default: ruby)
        #     -h, --help                       Print help information
        #
        # ## Arguments
        #
        #     URL | COOKIE                     The URL or the session cookie to parse
        #
        # @since 2.0.0
        #
        class SessionCookie < Command

          include CommandKit::Options::Verbose
          include CommandKit::Printing::Indent

          usage '[options] {URL | COOKIE}'

          option :format, short: '-F',
                          value: {
                            type: [:ruby, :json, :yaml],
                            default: :ruby
                          },
                          desc: 'The format to print the session cookie params'

          argument :url_or_cookie, required: true,
                                   usage:    'URL | COOKIE',
                                   desc:     'The URL or the session cookie to parse'

          description 'Parses and deserializes various session cookie formats'

          examples [
            '"rack.session=BAh7CEkiD3Nlc3Npb25faWQGOgZFVG86HVJhY2s6OlNlc3Npb246OlNlc3Npb25JZAY6D0BwdWJsaWNfaWRJIkUyYWJkZTdkM2I0YTMxNDE5OThiYmMyYTE0YjFmMTZlNTNlMWMzYWJlYzhiYzc4ZjVhMGFlMGUwODJmMjJlZGIxBjsARkkiCWNzcmYGOwBGSSIxNHY1TmRCMGRVaklXdjhzR3J1b2ZhM2xwNHQyVGp5ZHptckQycjJRWXpIZz0GOwBGSSINdHJhY2tpbmcGOwBGewZJIhRIVFRQX1VTRVJfQUdFTlQGOwBUSSItOTkxNzUyMWYzN2M4ODJkNDIyMzhmYmI5Yzg4MzFmMWVmNTAwNGQyYwY7AEY%3D--02184e43850f38a46c8f22ffb49f7f22be58e272"'
          ]

          man_page 'ronin-web-session-cookie.1'

          #
          # Runs the `ronin-web session-cookie` command.
          #
          # @param [String] arg
          #
          def run(arg)
            session_cookie = if arg.start_with?('https://') ||
                                arg.start_with?('http://')
                               fetch_session_cookie(arg)
                             else
                               parse_session_cookie(arg)
                             end

            if session_cookie
              print_session_cookie(session_cookie)
            else
              print_error "no session cookie found"
              exit(-1)
            end
          end

          #
          # Fetches the session cookie from the URL.
          #
          # @param [String] url
          #   The URL to request.
          #
          # @return [Ronin::Web::SessionCookie::Django, Ronin::Web::SessionCookie::JWT, Ronin::Web::SessionCookie::Rack, nil]
          #   The parses session cookie.
          #
          def fetch_session_cookie(url)
            response = begin
                         Support::Network::HTTP.get(url)
                       rescue => error
                         print_error "failed to request URL (#{url.inspect}): #{error.message}"
                         exit(-1)
                       end

            Web::SessionCookie.extract(response)
          end

          #
          # Parses a session cookie.
          #
          # @param [String] cookie
          #   The session cookie to parse.
          #
          # @return [Ronin::Web::SessionCookie::Django, Ronin::Web::SessionCookie::JWT, Ronin::Web::SessionCookie::Rack, nil]
          #   The parses session cookie.
          #
          def parse_session_cookie(cookie)
            Web::SessionCookie.parse(cookie)
          end

          #
          # Prints a session cookie.
          #
          # @param [Ronin::Web::SessionCookie::Django, Ronin::Web::SessionCookie::JWT, Ronin::Web::SessionCookie::Rack] session_cookie
          #
          # @raise [NotImplementedError]
          #   The session cookie was not `Ronin::Web::SessionCookie::Django`,
          #   `Ronin::Web::SessionCookie::JWT`, or
          #   `Ronin::Web::SessionCookie::Rack`.
          #
          def print_session_cookie(session_cookie)
            case session_cookie
            when Web::SessionCookie::Django
              print_django_session_cookie(session_cookie)
            when Web::SessionCookie::JWT
              print_jwt_session_cookie(session_cookie)
            when Web::SessionCookie::Rack
              print_rack_session_cookie(session_cookie)
            else
              raise(NotImplementedError,"cannot print session cookie: #{session_cookie.inspect}")
            end
          end

          #
          # Prints a Django session cookie.
          #
          # @param [Ronin::Web::SessionCookie::Django] session_cookie
          #
          def print_django_session_cookie(session_cookie)
            if verbose?
              puts "Type: Django"
              puts "Params:"
              puts

              indent do
                print_params(session_cookie.params)
              end
              puts

              puts "Salt: #{session_cookie.salt}"
              puts "HMAC: #{Support::Encoding::Hex.quote(session_cookie.hmac)}"
            else
              print_params(session_cookie.params)
            end
          end

          #
          # Prints a JWT session cookie.
          #
          # @param [Ronin::Web::SessionCookie::JWT] session_cookie
          #
          def print_jwt_session_cookie(session_cookie)
            if verbose?
              puts "Type: JWT"
              puts "Header:"
              puts

              indent do
                print_params(session_cookie.header)
              end
              puts

              puts "Params:"
              puts

              indent do
                print_params(session_cookie.params)
              end
              puts

              puts "HMAC: #{Support::Encoding::Hex.quote(session_cookie.hmac)}"
            else
              print_params(session_cookie.params)
            end
          end

          #
          # Prints a Rack session cookie.
          #
          # @param [Ronin::Web::SessionCookie::Rack] session_cookie
          #
          def print_rack_session_cookie(session_cookie)
            if verbose?
              puts "Type: Rack"
              puts "Params:"
              puts

              indent do
                print_params(session_cookie.params)
              end
              puts

              puts "HMAC: #{session_cookie.hmac}"
            else
              print_params(session_cookie.params)
            end
          end

          #
          # Prints the session cookie params as JSON.
          #
          # @param [Hash] params
          #   The params to print.
          #
          def print_params(params)
            format_params(params).each_line do |line|
              puts line
            end
          end

          #
          # Formats the params based on the `--format` option.
          #
          def format_params(params)
            case options[:format]
            when :ruby
              require 'pp'
              params.pretty_print_inspect
            when :json
              require 'json'
              JSON.pretty_generate(params)
            when :yaml
              require 'yaml'
              YAML.dump(params)
            else
              raise(NotImplementedError,"unsupported format: #{options[:format].inspect}")
            end
          end

        end
      end
    end
  end
end
