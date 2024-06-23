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
require 'ronin/web/spider/archive'
require 'ronin/web/spider/git_archive'
require 'ronin/support/network/http/user_agents'

require 'command_kit/colors'
require 'command_kit/printing/indent'
require 'command_kit/options/verbose'

module Ronin
  module Web
    class CLI
      module Commands
        #
        # Spiders a website.
        #
        # ## Usage
        #
        #     ronin-web spider [options] {--host HOST | --domain DOMAIN | --site URL}
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
        #     -P, --proxy PROXY                Sets the proxy to use
        #     -H, --header NAME: VALUE         Sets a default header
        #         --host-header NAME=VALUE     Sets a default header
        #     -U, --user-agent-string STRING   The User-Agent string to use
        #     -u chrome-linux|chrome-macos|chrome-windows|chrome-iphone|chrome-ipad|chrome-android|firefox-linux|firefox-macos|firefox-windows|firefox-iphone|firefox-ipad|firefox-android|safari-macos|safari-iphone|safari-ipad|edge,
        #         --user-agent                 The User-Agent to use
        #     -R, --referer URL                Sets the Referer URL
        #         --delay SECS                 Sets the delay in seconds between each request
        #     -l, --limit COUNT                Only spiders up to COUNT pages
        #     -d, --max-depth DEPTH            Only spiders up to max depth
        #         --enqueue URL                Adds the URL to the queue
        #         --visited URL                Marks the URL as previously visited
        #         --strip-fragments            Enables/disables stripping the fragment component of every URL
        #         --strip-query                Enables/disables stripping the query component of every URL
        #         --visit-scheme SCHEME        Visit URLs with the URI scheme
        #         --visit-schemes-like /REGEX/ Visit URLs with URI schemes that match the REGEX
        #         --ignore-scheme SCHEME       Ignore the URLs with the URI scheme
        #         --ignore-schemes-like /REGEX/
        #                                      Ignore the URLs with URI schemes matching the REGEX
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
        #         --print-stauts               Print the status codes for each URL
        #         --print-headers              Print response headers for each URL
        #         --print-header NAME          Prints a specific header
        #         --history FILE               The history file
        #         --archive DIR                Archive every visited page to the DIR
        #         --git-archive DIR            Archive every visited page to the git repository
        #     -X, --xpath XPATH                Evaluates the XPath on each HTML page
        #     -C, --css-path XPATH             Evaluates the CSS-path on each HTML page
        #         --print-hosts                Print all discovered hostnames
        #         --print-certs                Print all encountered SSL/TLS certificates
        #         --save-certs                 Saves all encountered SSL/TLS certificates
        #         --print-js-strings           Print all JavaScript strings
        #         --print-js-url-strings       Print URL strings found in JavaScript
        #         --print-js-path-strings      Print path strings found in JavaScript
        #         --print-js-relative-path-strings
        #                                      Only print relative path strings found in JavaScript
        #         --print-html-comments        Print HTML comments
        #         --print-js-comments          Print JavaScript comments
        #         --print-comments             Print all HTML and JavaScript comments
        #     -h, --help                       Print help information
        #
        # ## Examples
        #
        #     ronin-web spider --host scanme.nmap.org
        #     ronin-web spider --domain nmap.org
        #     ronin-web spider --site https://scanme.nmap.org/
        #
        class Spider < Command

          include SpiderOptions
          include CommandKit::Colors
          include CommandKit::Printing::Indent
          include CommandKit::Options::Verbose

          usage '[options] {--host HOST | --domain DOMAIN | --site URL}'

          option :print_stauts, desc: 'Print the status codes for each URL'

          option :print_headers, desc: 'Print response headers for each URL'

          option :print_header, value: {
                                  type:  String,
                                  usage: 'NAME'
                                },
                                desc: 'Prints a specific header'

          option :history, value: {
                             type:  String,
                             usage: 'FILE'
                           },
                           desc: 'The history file'

          option :archive, value: {
                             type:  String,
                             usage: 'DIR'
                           },
                           desc: 'Archive every visited page to the DIR'

          option :git_archive, value: {
                                 type:  String,
                                 usage: 'DIR'
                               },
                               desc: 'Archive every visited page to the git repository'

          option :xpath, short: '-X',
                         value: {
                           type:  String,
                           usage: 'XPATH'
                         },
                         desc: 'Evaluates the XPath on each HTML page'

          option :css_path, short: '-C',
                            value: {
                              type:  String,
                              usage: 'XPATH'
                            },
                            desc: 'Evaluates the CSS-path on each HTML page'

          option :print_hosts, desc: 'Print all discovered hostnames'

          option :print_certs, desc: 'Print all encountered SSL/TLS certificates'

          option :save_certs, desc: 'Saves all encountered SSL/TLS certificates'

          option :print_js_strings, desc: 'Print all JavaScript strings'

          option :print_js_url_strings, desc: 'Print URL strings found in JavaScript'

          option :print_js_path_strings, desc: 'Print path strings found in JavaScript'

          option :print_js_relative_path_strings, desc: 'Only print relative path strings found in JavaScript'

          option :print_html_comments, desc: 'Print HTML comments'

          option :print_js_comments, desc: 'Print JavaScript comments'

          option :print_comments, desc: 'Print all HTML and JavaScript comments'

          description 'Spiders a website'

          examples [
            "--host scanme.nmap.org",
            "--domain nmap.org",
            "--site https://scanme.nmap.org/"
          ]

          man_page 'ronin-web-spider.1'

          #
          # Runs the `ronin-web spider` command.
          #
          def run
            archive = if options[:archive]
                        Web::Spider::Archive.open(options[:archive])
                      elsif options[:git_archive]
                        Web::Spider::GitArchive.open(options[:git_archive])
                      end

            history_file = if options[:history]
                             File.open(options[:history],'w')
                           end

            agent = new_agent do |agent|
              agent.every_page do |page|
                print_page(page)
              end

              agent.every_failed_url do |url|
                print_verbose "failed to request #{url}"
              end

              define_printing_callbacks(agent)

              if history_file
                agent.every_page do |page|
                  history_file.puts(page.url)
                  history_file.flush
                end
              end

              if archive
                agent.every_ok_page do |page|
                  archive.write(page.url,page.body)
                end
              end
            end

            # post-spidering tasks

            if options[:git_archive]
              archive.commit "Updated #{Time.now}"
            end

            if options[:print_hosts]
              puts
              puts "Spidered the following hosts:"
              puts

              indent do
                agent.visited_hosts.each do |host|
                  puts host
                end
              end
            end

            if options[:print_certs]
              puts
              puts "Discovered the following certs:"
              puts

              agent.collected_certs.each do |cert|
                puts cert
                puts
              end
            end
          ensure
            if options[:history]
              history_file.close
            end
          end

          #
          # Defines callbacks that print information.
          #
          # @param [Ronin::Web::Spider::Agent] agent
          #   The newly created agent.
          #
          def define_printing_callbacks(agent)
            if options[:print_hosts]
              agent.every_host do |host|
                print_verbose "spidering new host #{host}"
              end
            end

            if options[:print_certs]
              agent.every_cert do |cert|
                print_verbose "encountered new certificate for #{cert.subject.common_name}"
              end
            end

            if options[:print_js_strings]
              agent.every_js_string do |string|
                print_content string
              end
            end

            if options[:print_js_url_strings]
              agent.every_js_url_string do |url|
                print_content url
              end
            end

            if options[:print_js_path_strings]
              agent.every_js_path_string do |path|
                print_content path
              end
            end

            if options[:print_js_relative_path_strings]
              agent.every_js_relative_path_string do |path|
                print_content path
              end
            end

            if options[:print_html_comments]
              agent.every_html_comment do |comment|
                print_content comment
              end
            end

            if options[:print_js_comments]
              agent.every_js_comment do |comment|
                print_content comment
              end
            end

            if options[:print_comments]
              agent.every_comment do |comment|
                print_content comment
              end
            end
          end

          #
          # Prints the status of a page.
          #
          # @param [Spidr::Page] page
          #   A spidered page.
          #
          def print_status(page)
            if page.code < 300
              print "#{colors.bright_green(page.code)} "
            elsif page.code < 400
              print "#{colors.bright_yellow(page.code)} "
            elsif page.code < 500
              print "#{colors.bright_red(page.code)} "
            else
              print "#{colors.bold(colors.bright_red(page.code))} "
            end
          end

          #
          # Prints the URL for a page.
          #
          # @param [Spidr::Page] page
          #   A spidered page.
          #
          def print_url(page)
            if page.code < 300
              puts "#{colors.green(page.url)} "
            elsif page.code < 400
              puts "#{colors.yellow(page.url)} "
            elsif page.code < 500
              puts "#{colors.red(page.url)} "
            else
              puts "#{colors.bold(colors.red(page.url))} "
            end
          end

          #
          # Prints a page.
          #
          # @param [Spidr::Page] page
          #   A spidered page.
          #
          def print_page(page)
            print_status(page) if options[:print_status]
            print_url(page)

            if options[:print_headers]
              print_headers(page)
            elsif options[:print_header]
              if (header = page.response[options[:print_header]])
                print_content header
              end
            end

            print_query(page) if (options[:xpath] || options[:css_path])
          end

          #
          # Prints the headers of a page.
          #
          # @param [Spidr::Page] page
          #   A spidered page.
          #
          def print_headers(page)
            page.response.each_capitalized do |name,value|
              print_content "#{name}: #{value}"
            end
          end

          #
          # Prints the XPath or CSS-path query result for the page.
          #
          # @param [Spidr::Page] page
          #   A spidered page.
          #
          def print_query(page)
            if page.html?
              if options[:xpath]
                print_content page.doc.xpath(options[:xpath])
              elsif options[:css_path]
                print_content page.doc.css(options[:css_path])
              end
            end
          end

          #
          # Prints an information message.
          #
          # @param [String] message
          #
          def print_verbose(message)
            if verbose?
              puts colors.yellow("* #{message}")
            end
          end

          #
          # Print content from a page.
          #
          # @param [#to_s] content
          #   The content to print.
          #
          def print_content(content)
            content.to_s.each_line do |line|
              puts "    #{line}"
            end
          end

        end
      end
    end
  end
end
