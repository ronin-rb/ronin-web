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
require 'ronin/vulns/cli/printing'
require 'ronin/vulns/cli/importable'

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
        #         --lfi-filter-bypass null-byte|double-escape|base64|rot13|zlib
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
          include SpiderOptions
          include Ronin::Vulns::CLI::Printing
          include Ronin::Vulns::CLI::Importable

          option :first, short: '-F',
                         desc:  'Stops spidering once the first vulnerability is found' do
                           @scan_mode = :first
                         end

          option :all, short: '-A',
                       desc:  'Spiders every URL and tests every param' do
                         @scan_mode = :all
                       end

          option :print_curl, desc: 'Also prints an example curl command for each vulnerability'

          option :print_http, desc: 'Also prints an example HTTP request for each vulnerability'

          option :import, desc: 'Imports discovered vulnerabilities into the database'

          option :lfi_os, value: {
                            type: [:unix, :windows]
                          },
                          desc: 'Sets the OS to test for' do |os|
                            lfi_kwargs[:os] = os
                          end

          option :lfi_depth, value: {
                               type:  Integer,
                               usage: 'COUNT'
                             },
                             desc: 'Sets the directory depth to escape up' do |depth|
                               lfi_kwargs[:depth] = depth
                             end

          option :lfi_filter_bypass, value: {
                                       type: {
                                         'null-byte'     => :null_byte,
                                         'double-escape' => :double_escape,
                                         'base64'        => :base64,
                                         'rot13'         => :rot13,
                                         'zlib'          => :zlib
                                       }
                                     },
                                     desc: 'Sets the filter bypass strategy to use' do |filter_bypass|
                                       lfi_kwargs[:filter_bypass] = filter_bypass
                                     end

          option :rfi_filter_bypass, value: {
                                       type: {
                                         'double-encode' => :double_encode,
                                         'suffix-escape' => :suffix_escape,
                                         'null-byte'     => :null_byte
                                       }
                                     },
                                     desc: 'Optional filter-bypass strategy to use' do |filter_bypass|
                                       rfi_kwargs[:filter_bypass] = filter_bypass
                                     end

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
                                   desc: 'Explicitly specify the scripting language to test for' do |script_lang|
                                     rfi_kwargs[:script_lang] = script_lang
                                   end

          option :rfi_test_script_url, value: {
                                         type:  String,
                                         usage: 'URL'
                                       },
                                       desc: 'Use an alternative test script URL' do |test_script_url|
                                         rfi_kwargs[:test_script_url] = test_script_url
                                       end

          option :sqli_escape_quote, desc: 'Escapes quotation marks' do
            sqli_kwargs[:escape_quote] = true
          end

          option :sqli_escape_parens, desc: 'Escapes parenthesis' do
            sqli_kwargs[:escape_parens] = true
          end

          option :sqli_terminate, desc: 'Terminates the SQL expression with a --' do
            sqli_kwargs[:terminate] = true
          end

          option :ssti_test_expr, value: {
                                    type: %r{\A\d+\s*[\*/\+\-]\s*\d+\z},
                                    usage: '{X*Y | X/Z | X+Y | X-Y}'
                                  },
                                  desc: 'Optional numeric test to use' do |expr|
                                    ssti_kwargs[:test_expr] = Ronin::Vulns::SSTI::TestExpression.parse(expr)
                                  end

          option :open_redirect_url, value: {
                                       type:  String,
                                       usage: 'URL'
                                     },
                                     desc: 'Optional test URL to try to redirect to' do |test_url|
                                       open_redirect_kwargs[:test_url] = test_url
                                     end

          description "Spiders a website and scans every URL for web vulnerabilities"

          man_page 'ronin-web-vulns.1'

          # The scan mode
          #
          # @return [:first, :all]
          attr_reader :scan_mode

          # Keyword arguments for `Ronin::Vulns::URLScanner.scan`.
          #
          # @return [Hash{Symbol => Object}]
          attr_reader :scan_kwargs

          #
          # Initializes the `ronin-web vulns` command.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments.
          #
          def initialize(**kwargs)
            super(**kwargs)

            @scan_mode   = :all
            @scan_kwargs = {}
          end

          #
          # Runs the `ronin-web vulns` command.
          #
          def run
            db_connect if options[:import]

            vulns = []

            begin
              new_agent do |agent|
                case @scan_mode
                when :first
                  agent.every_url do |url|
                    log_info "Testing #{url}"

                    if (vuln = test_url(url))
                      process_vuln(vuln)
                      vulns << vuln

                      agent.pause!
                    end
                  end
                when :all
                  agent.every_url do |url|
                    log_info "Testing #{url}"

                    scan_url(url) do |vuln|
                      process_vuln(vuln)
                      vulns << vuln
                    end
                  end
                end
              end
            rescue Interrupt
              puts
            end

            puts unless vulns.empty?
            print_vulns(vulns)
          end

          #
          # Logs and optioanlly imports a new discovered web vulnerability.
          #
          # @param [Ronin::Vulns::WebVuln] vuln
          #   The discovered web vulnerability.
          #
          def process_vuln(vuln)
            log_vuln(vuln)
            import_vuln(vuln) if options[:import]
          end

          #
          # Prints detailed information about a discovered web vulnerability.
          #
          # @param [WebVuln] vuln
          #   The web vulnerability to log.
          #
          # @param [Boolean] print_curl
          #   Prints an example `curl` command to trigger the web vulnerability.
          #
          # @param [Boolean] print_http
          #   Prints an example HTTP request to trigger the web vulnerability.
          #
          def print_vulns(vulns, print_curl: options[:print_curl],
                                 print_http: options[:print_http])
            super(vulns, print_curl: print_curl, print_http: print_http)
          end

          #
          # The default headers to send with every request.
          #
          # @return [Hash{String => String}]
          #
          # @since 2.0.0
          #
          def default_headers
            @scan_kwargs[:headers] ||= super
          end

          #
          # Sets the `User-Agent` header that will be sent with every request.
          #
          # @param [String] new_user_agent
          #
          # @return [String]
          #
          def user_agent=(new_user_agent)
            @scan_kwargs[:user_agent] ||= super(new_user_agent)
          end

          #
          # Sets the `Referer` header that will be sent with every request.
          #
          # @param [String] new_referer
          #
          # @return [String, nil]
          #
          # @note
          #   Also sets the `Referer` header that will be used during web
          #   vulnerability scanning.
          #
          def referer=(new_referer)
            @scan_kwargs[:referer] ||= super(new_referer)
          end

          #
          # @group URL Scanning Methods
          #

          #
          # Keyword arguments which will be passed to {URLScanner.scan} or
          # {URLScanner.test} via the `lfi:` keyword.
          #
          # @return [Hash{Symbol => Object}]
          #
          def lfi_kwargs
            @scan_kwargs[:lfi] ||= {}
          end

          #
          # Keyword arguments which will be passed to {URLScanner.scan} or
          # {URLScanner.test} via the `rfi:` keyword.
          #
          # @return [Hash{Symbol => Object}]
          #
          def rfi_kwargs
            @scan_kwargs[:rfi] ||= {}
          end

          #
          # Keyword arguments which will be passed to {URLScanner.scan} or
          # {URLScanner.test} via the `sqli:` keyword.
          #
          # @return [Hash{Symbol => Object}]
          #
          def sqli_kwargs
            @scan_kwargs[:sqli] ||= {}
          end

          #
          # Keyword arguments which will be passed to {URLScanner.scan} or
          # {URLScanner.test} via the `ssti:` keyword.
          #
          # @return [Hash{Symbol => Object}]
          #
          def ssti_kwargs
            @scan_kwargs[:ssti] ||= {}
          end

          #
          # Keyword arguments which will be passed to {URLScanner.scan} or
          # {URLScanner.test} via the `open_redirect:` keyword.
          #
          # @return [Hash{Symbol => Object}]
          #
          def open_redirect_kwargs
            @scan_kwargs[:open_redirect] ||= {}
          end

          #
          # Keyword arguments which will be passed to {URLScanner.scan} or
          # {URLScanner.test} via the `reflected_xss:` keyword.
          #
          # @return [Hash{Symbol => Object}]
          #
          def reflected_xss_kwargs
            @scan_kwargs[:reflected_xss] ||= {}
          end

          #
          # Scans the URL for web vulnerabilities.
          #
          # @param [URI::HTTP, String] url
          #   The URL to scan.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for `Ronin::Vulns::URLScanner.scan`.
          #
          # @yield [vuln]
          #   The given block will be yielded each discovered web vulnerability.
          #
          # @yieldparam [Ronin::Vulns::LFI,
          #              Ronin::Vulns::RFI,
          #              Ronin::Vulns::SQLI,
          #              Ronin::Vulns::SSTI,
          #              Ronin::Vulns::ReflectedXSS,
          #              Ronin::Vulns::OpenRedirect] vuln
          #   A discovered web vulnerability in the URL.
          #
          def scan_url(url,**kwargs,&block)
            Ronin::Vulns::URLScanner.scan(url,**kwargs,**@scan_kwargs,&block)
          end

          #
          # Tests the URL for web vulnerabilities and prints the first
          # vulnerability.
          #
          # @param [URI::HTTP, String] url
          #   The URL to scan.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for `Ronin::Vulns::URLScanner.test`.
          #
          # @return [Ronin::Vulns::LFI,
          #          Ronin::Vulns::RFI,
          #          Ronin::Vulns::SQLI,
          #          Ronin::Vulns::SSTI,
          #          Ronin::Vulns::ReflectedXSS,
          #          Ronin::Vulns::OpenRedirect, nil]
          #   The first discovered web vulnerability or `nil` if no
          #   vulnerabilities were discovered.
          #
          def test_url(url,**kwargs)
            Ronin::Vulns::URLScanner.test(url,**kwargs,**@scan_kwargs)
          end

        end
      end
    end
  end
end
