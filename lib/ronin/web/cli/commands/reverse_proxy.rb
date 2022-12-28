#
# ronin-web - A collection of useful web helper methods and commands.
#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/core/cli/logging'
require 'ronin/web/server/reverse_proxy'

module Ronin
  module Web
    class CLI
      module Commands
        #
        # Starts a HTTP proxy server.
        #
        # ## Usage
        #
        #     ronin-web reverse-proxy [options] [--host HOST] [--port PORT]
        #
        # ## Options
        #
        #     -H, --host HOST                  Host to listen on (Default: localhost)
        #     -p, --port PORT                  Port to listen on (Default: 8080)
        #     -b, --show-body                  Print the request and response bodies
        #         --rewrite-requests /REGEXP/:REPLACE
        #                                      Rewrite request bodies
        #         --rewrite-responses /REGEXP/:REPLACE
        #                                      Rewrite response bodies
        #     -h, --help                       Print help information
        #
        # @api private
        #
        class Proxy < Command

          include Core::CLI::Logging

          command_name 'reverse-proxy'

          usage '[options] [--host HOST] [--port PORT]'

          option :host, short: '-H',
                        value: {
                          type:    String,
                          usage:   'HOST',
                          default: 'localhost'
                        },
                        desc: 'Host to listen on'

          option :port, short: '-p',
                        value: {
                          type:   Integer,
                          usage:  'PORT',
                          default: 8080
                        },
                        desc: 'Port to listen on'

          option :show_body, short: '-b',
                             desc: 'Print the request and response bodies'

          option :rewrite_requests, value: {
                                      type: String,
                                      usage: '/REGEXP/:REPLACE'
                                    },
                                    desc: 'Rewrite request bodies' do |str|
                                      @rewrite_requests << parse_rewrite_rule(str)
                                    end

          option :rewrite_responses, value: {
                                       type: String,
                                       usage: '/REGEXP/:REPLACE'
                                     },
                                     desc: 'Rewrite response bodies' do |str|
                                       @rewrite_responses << parse_rewrite_rule(str)
                                     end

          description 'Starts a HTTP proxy server'

          man_page 'ronin-web-reverse-proxy.1'

          #
          # Initializes the `reverse-proxy` command.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments.
          #
          def initialize(**kwargs)
            super(**kwargs)

            @rewrite_requests  = []
            @rewrite_responses = []
          end

          #
          # Runs the `ronin-web reverse-proxy` command.
          #
          def run
            proxy = Ronin::Web::Server::ReverseProxy.new do |proxy|
              proxy.on_request do |request|
                puts "[#{request.ip} -> #{request.host_with_port}] #{request.request_method} #{request.url}"

                request.headers.each do |name,value|
                  puts "> #{name}: #{value}"
                end
                puts

                unless @rewrite_requests.empty?
                  request.body = rewrite_body(request.body,@rewrite_requests)
                end

                print_body(request.body) if options[:show_body]
              end

              proxy.on_response do |response|
                puts "< HTTP/1.1 #{response.status}"

                response.headers.each do |name,value|
                  puts "< #{name}: #{value}"
                end
                puts

                unless @rewrite_responses.empty?
                  response.body = rewrite_body(response.body,@rewrite_responses)
                end

                print_body(response.body) if options[:show_body]
              end
            end

            log_info "Starting proxy server on #{options[:host]}:#{options[:port]} ..."
            proxy.run!(host: options[:host], port: options[:port])
            log_info "shutting down ..."
          end

          #
          # Prints a request or response body.
          #
          # @param [IO, StringIO, Array<String>, String] body
          #   The request/response body to print. May be a IO/StringIO object,
          #   an Array of Strings, or a String.
          #
          def print_body(body)
            case body
            when StringIO, IO
              body.each_line do |line|
                puts line
              end

              body.rewind
            else
              puts body
            end
          end

          #
          # Parses a rewrite rule.
          #
          # @param [String] value
          #
          # @return [(Regexp, String), (String, String)]
          #
          def parse_rewrite_rule(value)
            if (index = value.rindex('/:'))
              regexp  = Regexp.new(value[1...index])
              replace = value[index+2..]

              return [regexp, replace]
            elsif (index = value.rindex(':'))
              string  = value[0...index]
              replace = value[(index+1)..]

              return [string, replace]
            end
          end
          
          #
          # Rewrites a request or response body.
          #
          # @param [IO, StringIO, Array<String>, String] body
          #
          # @return [String]
          #
          def rewrite_body(body,rules)
            body = case body
                   when StringIO, IO then body.read
                   when Array        then body.join
                   else                   body.to_s
                   end

            rules.each do |(pattern,replace)|
              body.gsub!(pattern,replace)
            end

            return body
          end

        end
      end
    end
  end
end
