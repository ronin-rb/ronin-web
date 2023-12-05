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
require 'ronin/web/cli/spider_options'
require 'ronin/core/cli/logging'
require 'ronin/vulns/url_scanner'
require 'ronin/vulns/cli/logging'

module Ronin
  module Web
    class CLI
      module Commands
        #
        # ## Usage
        #
        #     ronin-web vulns [options] {--host HOST | --domain DOMAIN | --site URL}
        #
        # ## Options
        #
        #         --host HOST                  Spiders the specific HOST
        #         --domain DOMAIN              Spiders the whole domain
        #         --site URL                   Spiders the website, starting at the URL
        #         --open-timeout SECS          Sets the connection open timeout
        #         --read-timeout SECS          Sets the read timeout
        #         --ssl-timeout SECS           Sets the SSL connection timeout
        #         --continue-timeout SECS      Sets the continue timeout
        #         --keep-alive-timeout SECS    Sets the connection keep alive timeout
        #     -P, --proxy PROXY                Sets the proxy to use.
        #     -H, --header NAME: VALUE         Sets a default header
        #         --host-header NAME=VALUE     Sets a default header
        #     -u chrome-linux|chrome-macos|chrome-windows|chrome-iphone|chrome-ipad|chrome-android|firefox-linux|firefox-macos|firefox-windows|firefox-iphone|firefox-ipad|firefox-android|safari-macos|safari-iphone|safari-ipad|edge,
        #         --user-agent                 The User-Agent to use
        #     -U, --user-agent-string STRING   The User-Agent string to use
        #     -R, --referer URL                Sets the Referer URL
        #         --delay SECS                 Sets the delay in seconds between each request
        #     -l, --limit COUNT                Only spiders up to COUNT pages
        #     -d, --max-depth DEPTH            Only spiders up to max depth
        #         --enqueue URL                Adds the URL to the queue
        #         --visited URL                Marks the URL as previously visited
        #         --strip-fragments            Enables/disables stripping the fragment component of every URL
        #         --strip-query                Enables/disables stripping the query component of every URL
        #         --visit-host HOST            Visit URLs with the matching host name
        #         --visit-hosts-like /REGEX/   Visit URLs with hostnames that match the REGEX
        #         --ignore-host HOST           Ignore the host name
        #         --ignore-hosts-like /REGEX/  Ignore the host names matching the REGEX
        #         --visit-port PORT            Visit URLs with the matching port number
        #         --visit-ports-like /REGEX/   Visit URLs with port numbers that match the REGEX
        #         --ignore-port PORT           Ignore the port number
        #         --ignore-ports-like /REGEX/  Ignore the port numbers matching the REGEXP
        #         --visit-link URL             Visit the URL
        #         --visit-links-like /REGEX/   Visit URLs that match the REGEX
        #         --ignore-link URL            Ignore the URL
        #         --ignore-links-like /REGEX/  Ignore URLs matching the REGEX
        #         --visit-ext FILE_EXT         Visit URLs with the matching file ext
        #         --visit-exts-like /REGEX/    Visit URLs with file exts that match the REGEX
        #         --ignore-ext FILE_EXT        Ignore the URLs with the file ext
        #         --ignore-exts-like /REGEX/   Ignore URLs with file exts matching the REGEX
        #     -r, --robots                     Specifies whether to honor robots.txt
        #     -v, --verbose                    Enables verbose output
        #         --lfi-os unix|windows        Sets the OS to test for
        #         --lfi-depth COUNT            Sets the directory depth to escape up
        #         --lfi-filter-bypass null_byte|double_escape|base64|rot13|zlib
        #                                      Sets the filter bypass strategy to use
        #         --rfi-filter-bypass double-encode|suffix-escape|null-byte
        #                                      Optional filter-bypass strategy to use
        #         --rfi-script-lang asp|asp.net|coldfusion|jsp|php|perl
        #                                      Explicitly specify the scripting language to test for
        #         --rfi-test-script-url URL    Use an alternative test script URL
        #         --sqli-escape-quote          Escapes quotation marks
        #         --sqli-escape-parens         Escapes parenthesis
        #         --sqli-terminate             Terminates the SQL expression with a --
        #         --ssti-test-expr {X*Y | X/Z | X+Y | X-Y}
        #                                      Optional numeric test to use
        #         --open-redirect-url URL      Optional test URL to try to redirect to
        #
        # @since 2.0.0
        #
        class Vulns < Command

          include Core::CLI::Logging
          include Ronin::Vulns::CLI::Logging
          include SpiderOptions

          option :lfi_os, value: {
                            type: [:unix, :windows]
                          },
                          desc: 'Sets the OS to test for'

          option :lfi_depth, value: {
                               type:  Integer,
                               usage: 'COUNT'
                             },
                             desc: 'Sets the directory depth to escape up'

          option :lfi_filter_bypass, value: {
                                       type: [
                                         :null_byte,
                                         :double_escape,
                                         :base64,
                                         :rot13,
                                         :zlib
                                       ]
                                     },
                                     desc: 'Sets the filter bypass strategy to use'

          option :rfi_filter_bypass, value: {
                                       type: {
                                         'double-encode' => :double_encode,
                                         'suffix-escape' => :suffix_escape,
                                         'null-byte'     => :null_byte
                                       }
                                     },
                                     desc: 'Optional filter-bypass strategy to use'

          option :rfi_script_lang, value: {
                                     type:  {
                                       'asp'        => :asp,
                                       'asp.net'    => :asp_net,
                                       'coldfusion' => :cold_fusion,
                                       'jsp'        => :jsp,
                                       'php'        => :php,
                                       'perl'       => :perl
                                     }
                                   },
                                   desc: 'Explicitly specify the scripting language to test for'

          option :rfi_test_script_url, value: {
                                         type:  String,
                                         usage: 'URL'
                                       },
                                       desc: 'Use an alternative test script URL'

          option :sqli_escape_quote, desc: 'Escapes quotation marks'

          option :sqli_escape_parens, desc: 'Escapes parenthesis'

          option :sqli_terminate, desc: 'Terminates the SQL expression with a --'

          option :ssti_test_expr, value: {
                                    type: %r{\A\d+\s*[\*/\+\-]\s*\d+\z},
                                    usage: '{X*Y | X/Z | X+Y | X-Y}'
                                  },
                                  desc: 'Optional numeric test to use' do |expr|
                                    @ssti_test_expr = Ronin::Vulns::SSTI::TestExpression.parse(expr)
                                  end

          option :open_redirect_url, value: {
                                       type:  String,
                                       usage: 'URL'
                                     },
                                     desc: 'Optional test URL to try to redirect to'

          description "Spiders a website and scans every URL for web vulnerabilities"

          man_page 'ronin-web-vulns.1'

          #
          # Runs the `ronin-web vulns` command.
          #
          def run
            new_agent do |agent|
              agent.every_url do |url|
                test_url(url)
              end
            end
          end

          #
          # Scans the URL for web vulnerabilities and prints every discovered
          # web vulnerability.
          #
          # @param [URI::HTTP, String] url
          #   The URL to scan.
          #
          def scan_url(url)
            Ronin::Vulns::URLScanner.scan(url) do |vuln|
              log_vuln(vuln)
            end
          end

          #
          # Tests the URL for web vulnerabilities and prints the first
          # vulnerability.
          #
          # @param [URI::HTTP, String] url
          #   The URL to scan.
          #
          def test_url(url)
            if (vuln = Ronin::Vulns::URLScanner.test(url))
              log_vuln(vuln)
            end
          end

        end
      end
    end
  end
end
