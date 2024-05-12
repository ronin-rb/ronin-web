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
                                        desc: 'Sets the connection open timeout' do |timeout|
                                          self.open_timeout = timeout
                                        end

          command.option :read_timeout, value: {
                                          type: Integer,
                                          usage: 'SECS',
                                          default: Spidr.read_timeout
                                        },
                                        desc: 'Sets the read timeout' do |timeout|
                                          self.read_timeout = timeout
                                        end

          command.option :ssl_timeout, value: {
                                         type: Integer,
                                         usage: 'SECS',
                                         default: Spidr.ssl_timeout
                                       },
                                       desc: 'Sets the SSL connection timeout' do |timeout|
                                         self.ssl_timeout = timeout
                                       end

          command.option :continue_timeout, value: {
                                              type:    Integer,
                                              usage:   'SECS',
                                              default: Spidr.continue_timeout
                                            },
                                            desc: 'Sets the continue timeout' do |timeout|
                                              self.continue_timeout = timeout
                                            end

          command.option :keep_alive_timeout, value: {
                                                type:    Integer,
                                                usage:   'SECS',
                                                default: Spidr.keep_alive_timeout
                                              },
                                              desc: 'Sets the connection keep alive timeout' do |timeout|
                                                self.keep_alive_timeout = timeout
                                              end

          command.option :proxy, short: '-P',
                                 value: {
                                   type:  String,
                                   usage: 'PROXY'
                                 },
                                 desc: 'Sets the proxy to use' do |proxy|
                                   self.proxy = proxy
                                 end

          command.option :header, short: '-H',
                                  value: {
                                    type:  /\A[^\s:]+:.*\z/,
                                    usage: 'NAME: VALUE'
                                  },
                                  desc: 'Sets a default header' do |header|
                                    name, value = header.split(/:\s*/,2)

                                    self.default_headers[name] = value
                                  end

          command.option :host_header, value: {
                                         type: /\A[^\s=]+=[^\s=]+\z/,
                                         usage: 'NAME=VALUE'
                                       },
                                       desc: 'Sets a default header' do |name_value|
                                         name, value = name_value.split('=',2)

                                         self.host_headers[name] = value
                                       end

          command.option :user_agent_string, short: '-U',
                                             value: {
                                               type:  String,
                                               usage: 'STRING'
                                             },
                                             desc: 'The User-Agent string to use' do |ua|
                                               self.user_agent = ua
                                             end

          command.option :user_agent, short: '-u',
                                      value: {
                                        type: Support::Network::HTTP::UserAgents::ALIASES.transform_keys { |key|
                                          key.to_s.tr('_','-')
                                        }
                                      },
                                      desc: 'The User-Agent to use' do |name|
                                        self.user_agent = name
                                      end

          command.option :referer, short: '-R',
                                   value: {
                                     type:  String,
                                     usage: 'URL'
                                   },
                                   desc: 'Sets the Referer URL' do |referer|
                                     self.referer = referer
                                   end

          command.option :delay, short: '-d',
                                 value: {
                                   type:  Numeric,
                                   usage: 'SECS'
                                 },
                                 desc: 'Sets the delay in seconds between each request' do |delay|
                                   self.delay = delay
                                 end

          command.option :limit, short: '-l',
                                 value: {
                                   type:  Integer,
                                   usage: 'COUNT'
                                 },
                                 desc: 'Only spiders up to COUNT pages' do |limit|
                                   self.limit = limit
                                 end

          command.option :max_depth, short: '-d',
                                     value: {
                                       type:  Integer,
                                       usage: 'DEPTH'
                                     },
                                     desc: 'Only spiders up to max depth' do |depth|
                                       self.max_depth = depth
                                     end

          command.option :enqueue, value: {
                                     type:  String,
                                     usage: 'URL'
                                   },
                                   desc: 'Adds the URL to the queue' do |url|
                                     self.queue << url
                                   end

          command.option :visited, value: {
                                     type:  String,
                                     usage: 'URL'
                                   },
                                   desc: 'Marks the URL as previously visited' do |url|
                                     self.history << url
                                   end

          command.option :strip_fragments, desc: 'Enables/disables stripping the fragment component of every URL' do
            self.strip_fragments = true
          end

          command.option :strip_query, desc: 'Enables/disables stripping the query component of every URL' do
            self.strip_query = true
          end

          command.option :visit_scheme, value: {
                                          type:  String,
                                          usage: 'SCHEME'
                                        },
                                        desc: 'Visit URLs with the URI scheme' do |scheme|
                                          self.visit_schemes << scheme
                                        end

          command.option :visit_schemes_like, value: {
                                                type:  Regexp,
                                                usage: '/REGEX/'
                                              },
                                              desc: 'Visit URLs with URI schemes that match the REGEX' do |regex|
                                                self.visit_schemes << regex
                                              end

          command.option :ignore_scheme, value: {
                                           type:  String,
                                           usage: 'SCHEME'
                                         },
                                         desc: 'Ignore the URLs with the URI scheme' do |scheme|
                                           self.ignore_schemes << scheme
                                         end

          command.option :ignore_schemes_like, value: {
                                                 type:  Regexp,
                                                 usage: '/REGEX/'
                                               },
                                               desc: 'Ignore the URLs with URI schemes matching the REGEX' do |regex|
                                                 self.ignore_schemes << regex
                                               end

          command.option :visit_host, value: {
                                        type:  String,
                                        usage: 'HOST'
                                      },
                                      desc: 'Visit URLs with the matching host name' do |host|
                                        self.visit_hosts << host
                                      end

          command.option :visit_hosts_like, value: {
                                              type:  Regexp,
                                              usage: '/REGEX/'
                                            },
                                            desc: 'Visit URLs with hostnames that match the REGEX' do |regex|
                                              self.visit_hosts << regex
                                            end

          command.option :ignore_host, value: {
                                         type:  String,
                                         usage: 'HOST'
                                       },
                                       desc: 'Ignore the host name' do |host|
                                         self.ignore_hosts << host
                                       end

          command.option :ignore_hosts_like, value: {
                                               type:  Regexp,
                                               usage: '/REGEX/'
                                             },
                                             desc: 'Ignore the host names matching the REGEX' do |regex|
                                               self.ignore_hosts << regex
                                             end

          command.option :visit_port, value: {
                                        type:  Integer,
                                        usage: 'PORT'
                                      },
                                      desc: 'Visit URLs with the matching port number' do |port|
                                        self.visit_ports << port
                                      end

          command.option :visit_ports_like, value: {
                                              type:  Regexp,
                                              usage: '/REGEX/'
                                            },
                                            desc: 'Visit URLs with port numbers that match the REGEX' do |regex|
                                              self.visit_ports << regex
                                            end

          command.option :ignore_port, value: {
                                         type:  Integer,
                                         usage: 'PORT'
                                       },
                                       desc: 'Ignore the port number' do |port|
                                         self.ignore_ports << port
                                       end

          command.option :ignore_ports_like, value: {
                                               type:  Regexp,
                                               usage: '/REGEX/'
                                             },
                                             desc: 'Ignore the port numbers matching the REGEXP' do |regex|
                                               self.ignore_ports << regex
                                             end

          command.option :visit_link, value: {
                                        type:  String,
                                        usage: 'URL'
                                      },
                                      desc: 'Visit the URL' do |link|
                                        self.visit_links << link
                                      end

          command.option :visit_links_like, value: {
                                              type:  Regexp,
                                              usage: '/REGEX/'
                                            },
                                            desc: 'Visit URLs that match the REGEX' do |regex|
                                              self.visit_links << regex
                                            end

          command.option :ignore_link, value: {
                                         type:  String,
                                         usage: 'URL'
                                       },
                                       desc: 'Ignore the URL' do |link|
                                         self.ignore_links << link
                                       end

          command.option :ignore_links_like, value: {
                                               type:  Regexp,
                                               usage: '/REGEX/'
                                             },
                                             desc: 'Ignore URLs matching the REGEX' do |regex|
                                               self.ignore_links << regex
                                             end

          command.option :visit_ext, value: {
                                       type:  String,
                                       usage: 'FILE_EXT'
                                     },
                                     desc: 'Visit URLs with the matching file ext' do |ext|
                                       self.visit_exts << ext
                                     end

          command.option :visit_exts_like, value: {
                                             type:  Regexp,
                                             usage: '/REGEX/'
                                           },
                                           desc: 'Visit URLs with file exts that match the REGEX' do |regex|
                                             self.visit_exts << regex
                                           end

          command.option :ignore_ext, value: {
                                        type:  String,
                                        usage: 'FILE_EXT'
                                      },
                                      desc: 'Ignore the URLs with the file ext' do |ext|
                                        self.ignore_exts << ext
                                      end

          command.option :ignore_exts_like, value: {
                                              type:  Regexp,
                                              usage: '/REGEX/'
                                            },
                                            desc: 'Ignore URLs with file exts matching the REGEX' do |regex|
                                              self.ignore_exts << regex
                                            end

          command.option :robots, short: '-r',
                                  desc:  'Specifies whether to honor robots.txt' do
                                    self.robots = true
                                  end
        end

        # Keyword arguments to initialize a new `Spidr::Agent`.
        #
        # @return [Hash{Symbol => Object}]
        #
        # @since 2.0.0
        attr_reader :agent_kwargs

        #
        # Initializes the command.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        def initialize(**kwargs)
          super(**kwargs)

          @agent_kwargs = {}
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
        # The open connection timeout.
        #
        # @return [Integer, nil]
        #
        # @since 2.0.0
        #
        def open_timeout
          @agent_kwargs[:open_timeout]
        end

        #
        # Sets the open connection timeout.
        #
        # @param [Integer] new_timeout
        #
        # @return [Integer]
        #
        # @since 2.0.0
        #
        def open_timeout=(new_timeout)
          @agent_kwargs[:open_timeout] = new_timeout
        end

        #
        # The read timeout.
        #
        # @return [Integer, nil]
        #
        # @since 2.0.0
        #
        def read_timeout
          @agent_kwargs[:read_timeout]
        end

        #
        # Sets the read timeout.
        #
        # @param [Integer] new_timeout
        #
        # @return [Integer]
        #
        # @since 2.0.0
        #
        def read_timeout=(new_timeout)
          @agent_kwargs[:read_timeout] = new_timeout
        end

        #
        # The SSL timeout.
        #
        # @return [Integer, nil]
        #
        # @since 2.0.0
        #
        def ssl_timeout
          @agent_kwargs[:ssl_timeout]
        end

        #
        # Sets the SSL timeout.
        #
        # @param [Integer] new_timeout
        #
        # @return [Integer]
        #
        # @since 2.0.0
        #
        def ssl_timeout=(new_timeout)
          @agent_kwargs[:ssl_timeout] = new_timeout
        end

        #
        # The continue timeout.
        #
        # @return [Integer, nil]
        #
        # @since 2.0.0
        #
        def continue_timeout
          @agent_kwargs[:continue_timeout]
        end

        #
        # Sets the continue timeout.
        #
        # @param [Integer] new_timeout
        #
        # @return [Integer]
        #
        # @since 2.0.0
        #
        def continue_timeout=(new_timeout)
          @agent_kwargs[:continue_timeout] = new_timeout
        end

        #
        # The `Keep-Alive` timeout.
        #
        # @return [Integer, nil]
        #
        # @since 2.0.0
        #
        def keep_alive_timeout
          @agent_kwargs[:keep_alive_timeout]
        end

        #
        # Sets the `Keep-Alive` timeout.
        #
        # @param [Integer] new_timeout
        #
        # @return [Integer]
        #
        # @since 2.0.0
        #
        def keep_alive_timeout=(new_timeout)
          @agent_kwargs[:keep_alive_timeout] = new_timeout
        end

        #
        # The proxy to use for spidering.
        #
        # @return [String, nil]
        #
        # @since 0.2.0
        #
        def proxy
          @agent_kwargs[:proxy]
        end

        #
        # Sets the proxy to use for spidering.
        #
        # @param [String] new_proxy
        #   The new proxy URI.
        #
        # @return [String]
        #
        # @since 2.0.0
        #
        def proxy=(new_proxy)
          @agent_kwargs[:proxy] = new_proxy
        end

        #
        # The default headers to send with every request.
        #
        # @return [Hash{String => String}]
        #
        # @since 2.0.0
        #
        def default_headers
          @agent_kwargs[:default_headers] ||= {}
        end

        #
        # The default `Host` headers to send with every request.
        #
        # @return [Hash{String => String}]
        #
        # @since 2.0.0
        #
        def host_headers
          @agent_kwargs[:host_headers] ||= {}
        end

        #
        # Sets the new `User-Agent` header to use for spidering.
        #
        # @return [String, nil]
        #
        # @since 2.0.0
        #
        def user_agent
          @agent_kwargs[:user_agent]
        end

        #
        # Sets the new `User-Agent` header to use for spidering.
        #
        # @param [String] new_user_agent
        #
        # @return [String]
        #
        # @since 2.0.0
        #
        def user_agent=(new_user_agent)
          @agent_kwargs[:user_agent] = new_user_agent
        end

        #
        # The `Referer` header to use for spidering.
        #
        # @return [String, nil]
        #
        # @since 2.0.0
        #
        def referer
          @agent_kwargs[:referer]
        end

        #
        # Sets the `Referer` header to use for spidering.
        #
        # @param [String] new_referer
        #
        # @return [String, nil]
        #
        # @since 2.0.0
        #
        def referer=(new_referer)
          @agent_kwargs[:referer] = new_referer
        end

        #
        # The amount of seconds to pause between each request.
        #
        # @return [Integer, Float, nil]
        #
        # @since 2.0.0
        #
        def delay
          @agent_kwargs[:delay]
        end

        #
        # Sets the amount of seconds to pause between each request.
        #
        # @param [Integer, Float] new_delay
        #
        # @return [Integer, Float]
        #
        # @since 2.0.0
        #
        def delay=(new_delay)
          @agent_kwargs[:delay] = new_delay
        end

        #
        # The limit to how many URLs to visit.
        #
        # @return [Integer, nil]
        #
        # @since 2.0.0
        #
        def limit
          @agent_kwargs[:limit]
        end

        #
        # Sets the limit of how many URLs to visit.
        #
        # @param [Integer] new_limit
        #
        # @return [Integer]
        #
        # @since 2.0.0
        #
        def limit=(new_limit)
          @agent_kwargs[:limit] = new_limit
        end

        #
        # The maximum depth to spider.
        #
        # @return [Integer, nil]
        #
        # @since 2.0.0
        #
        def max_depth
          @agent_kwargs[:max_depth]
        end

        #
        # Sets the maximum depth to spider.
        #
        # @param [Integer] new_max_depth
        #
        # @return [Integer]
        #
        # @since 2.0.0
        #
        def max_depth=(new_max_depth)
          @agent_kwargs[:max_depth] = new_max_depth
        end

        #
        # The pre-existing queue of URLs to start spidering.
        #
        # @return [Array<String>]
        #
        # @since 2.0.0
        #
        def queue
          @agent_kwargs[:queue] ||= []
        end

        #
        # The pre-existing history of URLs that have already been spidered.
        #
        # @return [Array<String>]
        #
        # @since 2.0.0
        #
        def history
          @agent_kwargs[:history] ||= []
        end

        #
        # Whether to strip the `#fragment` components of links.
        #
        # @return [Boolean]
        #
        # @since 2.0.0
        #
        def strip_fragments
          @agent_kwargs[:strip_fragments]
        end

        #
        # Sets whether to strip the `#fragment` components of links.
        #
        # @param [Boolean] new_value
        #
        # @return [Boolean]
        #
        # @since 2.0.0
        #
        def strip_fragments=(new_value)
          @agent_kwargs[:strip_fragments] = new_value
        end

        #
        # Whether to strip the `?query` components of links.
        #
        # @return [Boolean]
        #
        # @since 2.0.0
        #
        def strip_query
          @agent_kwargs[:strip_query]
        end

        #
        # Sets whether to strip the `?query` components of links.
        #
        # @param [Boolean] new_value
        #
        # @return [Boolean]
        #
        # @since 2.0.0
        #
        def strip_query=(new_value)
          @agent_kwargs[:strip_query] = new_value
        end

        #
        # The list of URI schemes to allow spidering.
        #
        # @return [Array<String>]
        #
        # @since 2.0.0
        #
        def visit_schemes
          @agent_kwargs[:schemes] ||= []
        end

        #
        # The list of URI hosts to allow spidering.
        #
        # @return [Array<String>]
        #
        # @since 2.0.0
        #
        def visit_hosts
          @agent_kwargs[:hosts] ||= []
        end

        #
        # The list of URI ports to allow spidering.
        #
        # @return [Array<Integer>]
        #
        # @since 2.0.0
        #
        def visit_ports
          @agent_kwargs[:ports] ||= []
        end

        #
        # The list of URI links to allow spidering.
        #
        # @return [Array<String>]
        #
        # @since 2.0.0
        #
        def visit_links
          @agent_kwargs[:links] ||= []
        end

        #
        # The list of URI file extensions to allow spidering.
        #
        # @return [Array<String>]
        #
        # @since 2.0.0
        #
        def visit_exts
          @agent_kwargs[:exts] ||= []
        end

        #
        # The list of URI schemes to ignore while spidering.
        #
        # @return [Array<String>]
        #
        # @since 2.0.0
        #
        def ignore_schemes
          @agent_kwargs[:ignore_schemes] ||= []
        end

        #
        # The list of URI hosts to ignore while spidering.
        #
        # @return [Array<String>]
        #
        # @since 2.0.0
        #
        def ignore_hosts
          @agent_kwargs[:ignore_hosts] ||= []
        end

        #
        # The list of URI ports to ignore while spidering.
        #
        # @return [Array<Integer>]
        #
        # @since 2.0.0
        #
        def ignore_ports
          @agent_kwargs[:ignore_ports] ||= []
        end

        #
        # The list of URI links to ignore while spidering.
        #
        # @return [Array<String>]
        #
        # @since 2.0.0
        #
        def ignore_links
          @agent_kwargs[:ignore_links] ||= []
        end

        #
        # The list of URI file extensions to ignore while spidering.
        #
        # @return [Array<String>]
        #
        # @since 2.0.0
        #
        def ignore_exts
          @agent_kwargs[:ignore_exts] ||= []
        end

        #
        # Whether to honor the `robots.txt` file while spidering.
        #
        # @return [Boolean]
        #
        # @since 2.0.0
        #
        def robots
          @agent_kwargs[:robots]
        end

        #
        # Sets whether to honor the `robots.txt` file while spidering.
        #
        # @param [Boolean] new_value
        #
        # @return [Boolean]
        #
        # @since 2.0.0
        #
        def robots=(new_value)
          @agent_kwargs[:robots] = new_value
        end
      end
    end
  end
end
