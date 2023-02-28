# frozen_string_literal: true
#
# ronin-web - A collection of useful web helper methods and commands.
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
require 'ronin/web/spider'
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
        #     -v, --verbose                    Enables verbose output
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
        #         --host HOST                  Spiders the specific HOST
        #         --domain DOMAIN              Spiders the whole domain
        #         --site URL                   Spiders the website, starting at the URL
        #         --print-status               Print the status codes for each URL
        #         --print-headers              Print response headers for each URL
        #         --print-header NAME          Prints a specific header
        #         --history FILE               The history file
        #         --archive DIR                Archive every visited page to the DIR
        #         --git-archive DIR            Archive every visited page to the git repository
        #     -X, --xpath XPATH                Evaluates the XPath on each HTML page
        #     -C, --css-path XPATH             Evaluates the CSS-path on each HTML page
        #     -h, --help                       Print help information
        #
        # ## Examples
        #
        #     ronin-web spider --host scanme.nmap.org
        #     ronin-web spider --domain nmap.org
        #     ronin-web spider --site https://scanme.nmap.org/
        #
        class Spider < Command

          include CommandKit::Colors
          include CommandKit::Printing::Indent
          include CommandKit::Options::Verbose

          usage '[options] {--host HOST | --domain DOMAIN | --site URL}'

          option :open_timeout, value: {
                                  type: Integer,
                                  usage: 'SECS',
                                  default: Spidr.open_timeout
                                },
                                desc: 'Sets the connection open timeout'

          option :read_timeout, value: {
                                  type: Integer,
                                  usage: 'SECS',
                                  default: Spidr.read_timeout
                                },
                                desc: 'Sets the read timeout'

          option :ssl_timeout, value: {
                                 type: Integer,
                                 usage: 'SECS',
                                 default: Spidr.ssl_timeout
                               },
                               desc: 'Sets the SSL connection timeout'

          option :continue_timeout, value: {
                                      type:    Integer,
                                      usage:   'SECS',
                                      default: Spidr.continue_timeout
                                    },
                                    desc: 'Sets the continue timeout'

          option :keep_alive_timeout, value: {
                                        type:    Integer,
                                        usage:   'SECS',
                                        default: Spidr.keep_alive_timeout
                                      },
                                      desc: 'Sets the connection keep alive timeout'

          option :proxy, short: '-P',
                         value: {
                           type:  String,
                           usage: 'PROXY'
                         },
                         desc: 'Sets the proxy to use'

          option :header, short: '-H',
                          value: {
                            type:  /\A[^\s:]+:.*\z/,
                            usage: 'NAME: VALUE'
                          },
                          desc: 'Sets a default header' do |header|
                            name, value = header.split(/:\s*/,2)

                            @default_headers[name] = value
                          end

          option :host_header, value: {
                                 type: /\A[^\s=]+=[^\s=]+\z/,
                                 usage: 'NAME=VALUE'
                               },
                               desc: 'Sets a default header' do |name_value|
                                 name, value = name_value.split('=',2)

                                 @host_headers[name] = value
                               end

          option :user_agent, value: {
                                type:  String,
                                usage: 'USER-AGENT'
                              },
                              desc: 'Sets the User-Agent string'

          option :user_agent_string, short: '-U',
                                     value: {
                                       type:  String,
                                       usage: 'STRING'
                                     },
                                     desc: 'The User-Agent string to use' do |ua|
                                       @user_agent = ua
                                     end

          option :user_agent, short: '-u',
                              value: {
                                type: Support::Network::HTTP::UserAgents::ALIASES.transform_keys { |key|
                                  key.to_s.tr('_','-')
                                }
                              },
                              desc: 'The User-Agent to use' do |name|
                                @user_agent = name
                              end

          option :referer, short: '-R',
                           value: {
                             type:  String,
                             usage: 'URL'
                           },
                           desc: 'Sets the Referer URL'

          option :delay, short: '-d',
                         value: {
                           type:  Numeric,
                           usage: 'SECS'
                         },
                         desc: 'Sets the delay in seconds between each request'

          option :limit, short: '-l',
                         value: {
                           type:  Integer,
                           usage: 'COUNT'
                         },
                         desc: 'Only spiders up to COUNT pages'

          option :max_depth, short: '-d',
                             value: {
                               type:  Integer,
                               usage: 'DEPTH'
                             },
                             desc: 'Only spiders up to max depth'

          option :enqueue, value: {
                             type:  String,
                             usage: 'URL'
                           },
                           desc: 'Adds the URL to the queue' do |url|
                             @queue << url
                           end

          option :visited, value: {
                             type:  String,
                             usage: 'URL'
                           },
                           desc: 'Marks the URL as previously visited' do |url|
                             @history << url
                           end

          option :strip_fragments, desc: 'Enables/disables stripping the fragment component of every URL'

          option :strip_query, desc: 'Enables/disables stripping the query component of every URL'

          option :visit_host, value: {
                                type:  String,
                                usage: 'HOST'
                              },
                              desc: 'Visit URLs with the matching host name' do |host|
                                @visit_hosts << host
                              end

          option :visit_hosts_like, value: {
                                      type:  Regexp,
                                      usage: '/REGEX/'
                                    },
                                    desc: 'Visit URLs with hostnames that match the REGEX' do |regex|
                                      @visit_hosts << regex
                                    end

          option :ignore_host, value: {
                                 type:  String,
                                 usage: 'HOST'
                               },
                               desc: 'Ignore the host name' do |host|
                                 @ignore_hosts << host
                               end

          option :ignore_hosts_like, value: {
                                       type:  Regexp,
                                       usage: '/REGEX/'
                                     },
                                     desc: 'Ignore the host names matching the REGEX' do |regex|
                                       @ignore_hosts << regex
                                     end

          option :visit_port, value: {
                                type:  Integer,
                                usage: 'PORT'
                              },
                              desc: 'Visit URLs with the matching port number' do |port|
                                @visit_ports << port
                              end

          option :visit_ports_like, value: {
                                      type:  Regexp,
                                      usage: '/REGEX/'
                                    },
                                    desc: 'Visit URLs with port numbers that match the REGEX' do |regex|
                                      @visit_ports << regex
                                    end

          option :ignore_port, value: {
                                 type:  Integer,
                                 usage: 'PORT'
                               },
                               desc: 'Ignore the port number' do |port|
                                 @ignore_ports << port
                               end

          option :ignore_ports_like, value: {
                                       type:  Regexp,
                                       usage: '/REGEX/'
                                     },
                                     desc: 'Ignore the port numbers matching the REGEXP' do |regex|
                                       @ignore_ports << regex
                                     end

          option :visit_link, value: {
                                type:  String,
                                usage: 'URL'
                              },
                              desc: 'Visit the URL' do |link|
                                @visit_links << link
                              end

          option :visit_links_like, value: {
                                      type:  Regexp,
                                      usage: '/REGEX/'
                                    },
                                    desc: 'Visit URLs that match the REGEX' do |regex|
                                      @visit_links << regex
                                    end

          option :ignore_link, value: {
                                 type:  String,
                                 usage: 'URL'
                               },
                               desc: 'Ignore the URL' do |link|
                                 @ignore_links << link
                               end

          option :ignore_links_like, value: {
                                       type:  Regexp,
                                       usage: '/REGEX/'
                                     },
                                     desc: 'Ignore URLs matching the REGEX' do |regex|
                                       @ignore_links << regex
                                     end

          option :visit_ext, value: {
                               type:  String,
                               usage: 'FILE_EXT'
                             },
                             desc: 'Visit URLs with the matching file ext' do |ext|
                               @visit_exts << ext
                             end

          option :visit_exts_like, value: {
                                     type:  Regexp,
                                     usage: '/REGEX/'
                                   },
                                   desc: 'Visit URLs with file exts that match the REGEX' do |regex|
                                     @visit_exts << regex
                                   end

          option :ignore_ext, value: {
                                type:  String,
                                usage: 'FILE_EXT'
                              },
                              desc: 'Ignore the URLs with the file ext' do |ext|
                                @ignore_exts << ext
                              end

          option :ignore_exts_like, value: {
                                      type:  Regexp,
                                      usage: '/REGEX/'
                                    },
                                    desc: 'Ignore URLs with file exts matching the REGEX' do |regex|
                                      @ignore_exts << regex
                                    end

          option :robots, short: '-r',
                          desc:  'Specifies whether to honor robots.txt'

          option :host, value: {
                          type:  String,
                          usage: 'HOST'
                        },
                        desc: 'Spiders the specific HOST'

          option :domain, value: {
                            type:  String,
                            usage: 'DOMAIN'
                          },
                          desc: 'Spiders the whole domain'

          option :site, value: {
                          type:  String,
                          usage: 'URL'
                        },
                        desc: 'Spiders the website, starting at the URL'

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

          # The default HTTP headers to send with every request.
          #
          # @return [Hash{String => String}]
          attr_reader :default_headers

          # The mapping of custom `Host` headers.
          #
          # @return [Hash{String => String}]
          attr_reader :host_headers

          # The pre-existing queue of URLs to start spidering with.
          #
          # @return [Array<String>]
          attr_reader :queue

          # The pre-existing of previously visited URLs to start spidering with.
          #
          # @return [Array<String>]
          attr_reader :history

          # The schemes to visit.
          #
          # @return [Array<String>]
          attr_reader :visit_schemes

          # The hosts to visit.
          #
          # @return [Array<String, Regexp>]
          attr_reader :visit_hosts

          # The port numbers to visit.
          #
          # @return [Array<Integer, Regexp>]
          attr_reader :visit_ports

          # The links to visit.
          #
          # @return [Array<String, Regexp>]
          attr_reader :visit_links

          # The URL file extensions to visit.
          #
          # @return [Array<String, Regexp>]
          attr_reader :visit_exts

          # The hosts to ignore.
          #
          # @return [Array<String, Regexp>]
          attr_reader :ignore_hosts

          # The port numbers to ignore.
          #
          # @return [Array<Integer, Regexp>]
          attr_reader :ignore_ports

          # The links to ignore.
          #
          # @return [Array<String, Regexp>]
          attr_reader :ignore_links

          # The URL file extensions to ignore.
          #
          # @return [Array<String, Regexp>]
          attr_reader :ignore_exts

          #
          # Initializes the spider command.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments.
          #
          def initialize(**kwargs)
            super(**kwargs)

            @default_headers = {}
            @host_headers    = {}

            @queue   = []
            @history = []

            @visit_schemes = []
            @visit_hosts   = []
            @visit_ports   = []
            @visit_links   = []
            @visit_exts    = []

            @ignore_hosts = []
            @ignore_ports = []
            @ignore_links = []
            @ignore_exts  = []
          end

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
          # Creates a new web spider agent.
          #
          # @yield [agent]
          #   The given block will be given the newly created and configured
          #   web spider agent.
          #
          # @yieldparam [Ronin::Web::Spider::Agent] agent
          #   The newly created web spider agent.
          #
          # @return [Ronin::Web::Spider::Agent]
          #   The newly created web spider agent, after the agent has completed
          #   it's spidering.
          #
          def new_agent(&block)
            if options[:host]
              Web::Spider.host(options[:host],**agent_kwargs,&block)
            elsif options[:domain]
              Web::Spider.domain(options[:domain],**agent_kwargs,&block)
            elsif options[:site]
              Web::Spider.site(options[:site],**agent_kwargs,&block)
            else
              print_error "must specify --host, --domain, or --site"
              exit(-1)
            end
          end

          #
          # Builds keyword arguments for `Ronin::Web::Spider::Agent#initialize`.
          #
          # @return [Hash{Symbol => Object}]
          #   The keyword arguments for `Ronin::Web::Spider::Agent#initialize`.
          #
          def agent_kwargs
            kwargs = {}

            kwargs[:proxy] = options[:proxy] if options[:proxy]

            unless @default_headers.empty?
              kwargs[:default_headers] = @default_headers
            end

            unless @host_headers.empty?
              kwargs[:host_headers] = @host_headers
            end

            kwargs[:user_agent] = @user_agent       if @user_agent
            kwargs[:referer]    = options[:referer] if options[:referer]

            kwargs[:delay]     = options[:delay]     if options[:delay]
            kwargs[:limit]     = options[:limit]     if options[:limit]
            kwargs[:max_depth] = options[:max_depth] if options[:max_depth]

            kwargs[:queue]   = @queue   unless @queue.empty?
            kwargs[:history] = @history unless @history.empty?

            if options.has_key?(:strip_fragments)
              kwargs[:strip_fragments] = options[:strip_fragments]
            end

            if options.has_key?(:strip_query)
              kwargs[:strip_query] = options[:strip_query]
            end

            kwargs[:schemes] = @visit_schemes unless @visit_schemes.empty?
            kwargs[:hosts]   = @visit_hosts   unless @visit_hosts.empty?
            kwargs[:ports]   = @visit_ports   unless @visit_ports.empty?
            kwargs[:links]   = @visit_links   unless @visit_links.empty?
            kwargs[:exts]    = @visit_exts    unless @visit_exts.empty?

            kwargs[:ignore_hosts] = @ignore_hosts unless @ignore_hosts.empty?
            kwargs[:ignore_ports] = @ignore_ports unless @ignore_ports.empty?
            kwargs[:ignore_links] = @ignore_links unless @ignore_links.empty?
            kwargs[:ignore_exts]  = @ignore_exts  unless @ignore_exts.empty?

            kwargs[:robots] = options[:robots] if options.has_key?(:robots)

            return kwargs
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
