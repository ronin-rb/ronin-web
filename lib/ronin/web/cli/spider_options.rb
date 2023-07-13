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

require 'ronin/web/spider'
require 'ronin/support/network/http/user_agents'

module Ronin
  module Web
    class CLI
      #
      # Adds options for spidering a website.
      #
      # @since 2.0.0
      #
      module SpiderOptions
        #
        # Adds options for configuring a web spider and spidering a website.
        #
        # @param [Class<Command>] command
        #   The command class including {SpiderOptions}.
        #
        def self.included(command)
          command.usage '[options] {--host HOST | --domain DOMAIN | --site URL}'

          command.option :host, value: {
                                  type:  String,
                                  usage: 'HOST'
                                },
                                desc: 'Spiders the specific HOST'

          command.option :domain, value: {
                                    type:  String,
                                    usage: 'DOMAIN'
                                  },
                                  desc: 'Spiders the whole domain'

          command.option :site, value: {
                                  type:  String,
                                  usage: 'URL'
                                },
                                desc: 'Spiders the website, starting at the URL'

          command.option :open_timeout, value: {
                                          type: Integer,
                                          usage: 'SECS',
                                          default: Spidr.open_timeout
                                        },
                                        desc: 'Sets the connection open timeout'

          command.option :read_timeout, value: {
                                          type: Integer,
                                          usage: 'SECS',
                                          default: Spidr.read_timeout
                                        },
                                        desc: 'Sets the read timeout'

          command.option :ssl_timeout, value: {
                                         type: Integer,
                                         usage: 'SECS',
                                         default: Spidr.ssl_timeout
                                       },
                                       desc: 'Sets the SSL connection timeout'

          command.option :continue_timeout, value: {
                                              type:    Integer,
                                              usage:   'SECS',
                                              default: Spidr.continue_timeout
                                            },
                                            desc: 'Sets the continue timeout'

          command.option :keep_alive_timeout, value: {
                                                type:    Integer,
                                                usage:   'SECS',
                                                default: Spidr.keep_alive_timeout
                                              },
                                              desc: 'Sets the connection keep alive timeout'

          command.option :proxy, short: '-P',
                                 value: {
                                   type:  String,
                                   usage: 'PROXY'
                                 },
                                 desc: 'Sets the proxy to use'

          command.option :header, short: '-H',
                                  value: {
                                    type:  /\A[^\s:]+:.*\z/,
                                    usage: 'NAME: VALUE'
                                  },
                                  desc: 'Sets a default header' do |header|
                                    name, value = header.split(/:\s*/,2)

                                    @default_headers[name] = value
                                  end

          command.option :host_header, value: {
                                         type: /\A[^\s=]+=[^\s=]+\z/,
                                         usage: 'NAME=VALUE'
                                       },
                                       desc: 'Sets a default header' do |name_value|
                                         name, value = name_value.split('=',2)

                                         @host_headers[name] = value
                                       end

          command.option :user_agent_string, short: '-U',
                                             value: {
                                               type:  String,
                                               usage: 'STRING'
                                             },
                                             desc: 'The User-Agent string to use' do |ua|
                                               @user_agent = ua
                                             end

          command.option :user_agent, short: '-u',
                                      value: {
                                        type: Support::Network::HTTP::UserAgents::ALIASES.transform_keys { |key|
                                          key.to_s.tr('_','-')
                                        }
                                      },
                                      desc: 'The User-Agent to use' do |name|
                                        @user_agent = name
                                      end

          command.option :referer, short: '-R',
                                   value: {
                                     type:  String,
                                     usage: 'URL'
                                   },
                                   desc: 'Sets the Referer URL'

          command.option :delay, short: '-d',
                                 value: {
                                   type:  Numeric,
                                   usage: 'SECS'
                                 },
                                 desc: 'Sets the delay in seconds between each request'

          command.option :limit, short: '-l',
                                 value: {
                                   type:  Integer,
                                   usage: 'COUNT'
                                 },
                                 desc: 'Only spiders up to COUNT pages'

          command.option :max_depth, short: '-d',
                                     value: {
                                       type:  Integer,
                                       usage: 'DEPTH'
                                     },
                                     desc: 'Only spiders up to max depth'

          command.option :enqueue, value: {
                                     type:  String,
                                     usage: 'URL'
                                   },
                                   desc: 'Adds the URL to the queue' do |url|
                                     @queue << url
                                   end

          command.option :visited, value: {
                                     type:  String,
                                     usage: 'URL'
                                   },
                                   desc: 'Marks the URL as previously visited' do |url|
                                     @history << url
                                   end

          command.option :strip_fragments, desc: 'Enables/disables stripping the fragment component of every URL'

          command.option :strip_query, desc: 'Enables/disables stripping the query component of every URL'

          command.option :visit_scheme, value: {
                                          type:  String,
                                          usage: 'SCHEME'
                                        },
                                        desc: 'Visit URLs with the URI scheme' do |scheme|
                                          @visit_schemes << scheme
                                        end

          command.option :visit_schemes_like, value: {
                                                type:  Regexp,
                                                usage: '/REGEX/'
                                              },
                                              desc: 'Visit URLs with URI schemes that match the REGEX' do |regex|
                                                @visit_schemes << regex
                                              end

          command.option :ignore_scheme, value: {
                                           type:  String,
                                           usage: 'SCHEME'
                                         },
                                         desc: 'Ignore the URLs with the URI scheme' do |scheme|
                                           @ignore_schemes << scheme
                                         end

          command.option :ignore_schemes_like, value: {
                                                 type:  Regexp,
                                                 usage: '/REGEX/'
                                               },
                                               desc: 'Ignore the URLs with URI schemes matching the REGEX' do |regex|
                                                 @ignore_schemes << regex
                                               end

          command.option :visit_host, value: {
                                        type:  String,
                                        usage: 'HOST'
                                      },
                                      desc: 'Visit URLs with the matching host name' do |host|
                                        @visit_hosts << host
                                      end

          command.option :visit_hosts_like, value: {
                                              type:  Regexp,
                                              usage: '/REGEX/'
                                            },
                                            desc: 'Visit URLs with hostnames that match the REGEX' do |regex|
                                              @visit_hosts << regex
                                            end

          command.option :ignore_host, value: {
                                         type:  String,
                                         usage: 'HOST'
                                       },
                                       desc: 'Ignore the host name' do |host|
                                         @ignore_hosts << host
                                       end

          command.option :ignore_hosts_like, value: {
                                               type:  Regexp,
                                               usage: '/REGEX/'
                                             },
                                             desc: 'Ignore the host names matching the REGEX' do |regex|
                                               @ignore_hosts << regex
                                             end

          command.option :visit_port, value: {
                                        type:  Integer,
                                        usage: 'PORT'
                                      },
                                      desc: 'Visit URLs with the matching port number' do |port|
                                        @visit_ports << port
                                      end

          command.option :visit_ports_like, value: {
                                              type:  Regexp,
                                              usage: '/REGEX/'
                                            },
                                            desc: 'Visit URLs with port numbers that match the REGEX' do |regex|
                                              @visit_ports << regex
                                            end

          command.option :ignore_port, value: {
                                         type:  Integer,
                                         usage: 'PORT'
                                       },
                                       desc: 'Ignore the port number' do |port|
                                         @ignore_ports << port
                                       end

          command.option :ignore_ports_like, value: {
                                               type:  Regexp,
                                               usage: '/REGEX/'
                                             },
                                             desc: 'Ignore the port numbers matching the REGEXP' do |regex|
                                               @ignore_ports << regex
                                             end

          command.option :visit_link, value: {
                                        type:  String,
                                        usage: 'URL'
                                      },
                                      desc: 'Visit the URL' do |link|
                                        @visit_links << link
                                      end

          command.option :visit_links_like, value: {
                                              type:  Regexp,
                                              usage: '/REGEX/'
                                            },
                                            desc: 'Visit URLs that match the REGEX' do |regex|
                                              @visit_links << regex
                                            end

          command.option :ignore_link, value: {
                                         type:  String,
                                         usage: 'URL'
                                       },
                                       desc: 'Ignore the URL' do |link|
                                         @ignore_links << link
                                       end

          command.option :ignore_links_like, value: {
                                               type:  Regexp,
                                               usage: '/REGEX/'
                                             },
                                             desc: 'Ignore URLs matching the REGEX' do |regex|
                                               @ignore_links << regex
                                             end

          command.option :visit_ext, value: {
                                       type:  String,
                                       usage: 'FILE_EXT'
                                     },
                                     desc: 'Visit URLs with the matching file ext' do |ext|
                                       @visit_exts << ext
                                     end

          command.option :visit_exts_like, value: {
                                             type:  Regexp,
                                             usage: '/REGEX/'
                                           },
                                           desc: 'Visit URLs with file exts that match the REGEX' do |regex|
                                             @visit_exts << regex
                                           end

          command.option :ignore_ext, value: {
                                        type:  String,
                                        usage: 'FILE_EXT'
                                      },
                                      desc: 'Ignore the URLs with the file ext' do |ext|
                                        @ignore_exts << ext
                                      end

          command.option :ignore_exts_like, value: {
                                              type:  Regexp,
                                              usage: '/REGEX/'
                                            },
                                            desc: 'Ignore URLs with file exts matching the REGEX' do |regex|
                                              @ignore_exts << regex
                                            end

          command.option :robots, short: '-r',
                                  desc:  'Specifies whether to honor robots.txt'
        end

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

        # The URI schemes to visit.
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

        # The URI schemes to ignore.
        #
        # @return [Array<String, Regexp>]
        attr_reader :ignore_schemes

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
        # Initializes the command.
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

          @ignore_schemes = []
          @ignore_hosts   = []
          @ignore_ports   = []
          @ignore_links   = []
          @ignore_exts    = []
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

          if options[:open_timeout]
            kwargs[:open_timeout] = options[:open_timeout]
          end

          if options[:read_timeout]
            kwargs[:read_timeout] = options[:read_timeout]
          end

          if options[:ssl_timeout]
            kwargs[:ssl_timeout] = options[:ssl_timeout]
          end

          if options[:continue_timeout]
            kwargs[:continue_timeout] = options[:continue_timeout]
          end

          if options[:keep_alive_timeout]
            kwargs[:keep_alive_timeout] = options[:keep_alive_timeout]
          end

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

          unless @ignore_schemes.empty?
            kwargs[:ignore_schemes] = @ignore_schemes
          end

          unless @ignore_hosts.empty?
            kwargs[:ignore_hosts] = @ignore_hosts
          end

          unless @ignore_ports.empty?
            kwargs[:ignore_ports] = @ignore_ports
          end

          unless @ignore_links.empty?
            kwargs[:ignore_links] = @ignore_links
          end

          unless @ignore_exts.empty?
            kwargs[:ignore_exts] = @ignore_exts
          end

          kwargs[:robots] = options[:robots] if options.has_key?(:robots)

          return kwargs
        end
      end
    end
  end
end
