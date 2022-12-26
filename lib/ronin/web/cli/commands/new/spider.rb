# frozen_string_literal: true
#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-web.
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
require 'ronin/web/root'

require 'ronin/core/cli/generator'

module Ronin
  module Web
    class CLI
      module Commands
        class New < Command
          #
          # Creates a new [ronin-web-spider] script.
          #
          # [ronin-web-spider]: https://github.com/ronin-rb/ronin-web-spider#readme
          #
          # ## Usage
          #
          #     ronin-web spider [options] {--host[=HOST] | --domain[=DOMAIN] | --site[=URL]} FILE
          #
          # ## Options
          #
          #         --host[=[HOST]]              Spiders a host
          #         --domain[=[DOMAIN]]          Spiders a domain
          #         --site[=[URL]]               Spiders a site
          #         --every-link                 Adds a callback for every link
          #         --every-url                  Adds a callback for every URL
          #         --every-failed-url           Adds a callback for every failed URL
          #         --every-url-like /REGEXP/    Adds a callback for every URL that matches the regexp
          #         --all-headers                Adds a callback for all HTTP Headers
          #         --every-page                 Adds a callback for every page
          #         --every-ok-page              Adds a callback for every HTTP 200 page
          #         --every-redirect-page        Adds a callback for every redirect page
          #         --every-timedout-page        Adds a callback for every timedout page
          #         --every-bad-request-page     Adds a callback for every bad request page
          #         --every-unauthorized-page    Adds a callback for every unauthorized page
          #         --every-forbidden-page       Adds a callback for every forbidden page
          #         --every-missing-page         Adds a callback for every missing page
          #         --every-internal-server-error-page
          #                                      Adds a callback for every internal server error page
          #         --every-txt-page             Adds a callback for every TXT page
          #         --every-html-page            Adds a callback for every HTML page
          #         --every-xml-page             Adds a callback for every XML page
          #         --every-xsl-page             Adds a callback for every XSL page
          #         --every-javascript-page      Adds a callback for every JavaScript page
          #         --every-css-page             Adds a callback for every CSS page
          #         --every-rss-page             Adds a callback for every RSS page
          #         --every-atom-page            Adds a callback for every Atom page
          #         --every-ms-word-page         Adds a callback for every MS Wod page
          #         --every-pdf-page             Adds a callback for every PDF page
          #         --every-zip-page             Adds a callback for every ZIP page
          #         --every-doc                  Adds a callback for every HTML/XML document
          #         --every-html-doc             Adds a callback for every HTML document
          #         --every-xml-doc              Adds a callback for every XML document
          #         --every-xsl-doc              Adds a callback for every XSL document
          #         --every-rss-doc              Adds a callback for every RSS document
          #         --every-atom-doc             Adds a callback for every Atom document
          #     -h, --help                       Print help information
          #
          # ## Arguments
          #
          #     FILE                             The file to create
          #
          class Spider < Command

            include Core::CLI::Generator

            template_dir File.join(ROOT,'data','new')

            usage '[options] {--host[=HOST] | --domain[=DOMAIN] | --site[=URL]} FILE'

            option :host, equals: true,
                          value: {
                            type:    String,
                            usage:   'HOST',
                            required: false
                          },
                          desc: 'Spiders a host' do |value|
                            @entry_point_method   = :host
                            @entry_point_argument = value
                          end

            option :domain, equals: true,
                            value: {
                              type:    String,
                              usage:   'DOMAIN',
                              required: false
                            },
                            desc: 'Spiders a domain' do |value|
                            @entry_point_method   = :domain
                            @entry_point_argument = value
                          end


            option :site, equals: true,
                          value: {
                            type:    String,
                            usage:   'URL',
                            required: false
                          },
                          desc: 'Spiders a site' do |value|
                            @entry_point_method   = :site
                            @entry_point_argument = value
                          end

            option :every_link, desc: 'Adds a callback for every link' do
              @callbacks << [:every_link, [], :link]
            end

            option :every_url, desc: 'Adds a callback for every URL' do
              @callbacks << [:every_url, [], :url]
            end

            option :every_failed_url, desc: 'Adds a callback for every failed URL' do
              @callbacks << [:every_failed_url, [], :url]
            end

            option :every_url_like, value: {
                                      type:  Regexp,
                                      usage: '/REGEXP/'
                                    },
                                    desc: 'Adds a callback for every URL that matches the regexp' do |regexp|
                                      @callbacks << [:every_url_like, [regexp], :url]
                                    end

            option :all_headers, desc: 'Adds a callback for all HTTP Headers' do
              @callbacks << [:all_headers, [], :headers]
            end

            option :every_page, desc: 'Adds a callback for every page' do
              @callbacks << [:every_page, [], :page]
            end

            option :every_ok_page, desc: 'Adds a callback for every HTTP 200 page' do
              @callbacks << [:every_ok_page, [], :page]
            end

            option :every_redirect_page, desc: 'Adds a callback for every redirect page' do
              @callbacks << [:every_redirect_page, [], :page]
            end

            option :every_timedout_page, desc: 'Adds a callback for every timedout page' do
              @callbacks << [:every_timedout_page, [], :page]
            end

            option :every_bad_request_page, desc: 'Adds a callback for every bad request page' do
              @callbacks << [:every_bad_request_page, [], :page]
            end

            option :every_unauthorized_page, desc: 'Adds a callback for every unauthorized page' do
              @callbacks << [:every_unauthorized_page, [], :page]
            end

            option :every_forbidden_page, desc: 'Adds a callback for every forbidden page' do
              @callbacks << [:every_forbidden_page, [], :page]
            end

            option :every_missing_page, desc: 'Adds a callback for every missing page' do
              @callbacks << [:every_missing_page, [], :page]
            end

            option :every_internal_server_error_page, desc: 'Adds a callback for every internal server error page' do
              @callbacks << [:every_internal_server_error_page, [], :page]
            end

            option :every_txt_page, desc: 'Adds a callback for every TXT page' do
              @callbacks << [:every_txt_page, [], :page]
            end

            option :every_html_page, desc: 'Adds a callback for every HTML page' do
              @callbacks << [:every_html_page, [], :page]
            end

            option :every_xml_page, desc: 'Adds a callback for every XML page' do
              @callbacks << [:every_xml_page, [], :page]
            end

            option :every_xsl_page, desc: 'Adds a callback for every XSL page' do
              @callbacks << [:every_xsl_page, [], :page]
            end

            option :every_javascript_page, desc: 'Adds a callback for every JavaScript page' do
              @callbacks << [:every_javascript_page, [], :page]
            end

            option :every_css_page, desc: 'Adds a callback for every CSS page' do
              @callbacks << [:every_css_page, [], :page]
            end

            option :every_rss_page, desc: 'Adds a callback for every RSS page' do
              @callbacks << [:every_rss_page, [], :page]
            end

            option :every_atom_page, desc: 'Adds a callback for every Atom page' do
              @callbacks << [:every_atom_page, [], :page]
            end

            option :every_ms_word_page, desc: 'Adds a callback for every MS Wod page' do
              @callbacks << [:every_ms_wod_page, [], :page]
            end

            option :every_pdf_page, desc: 'Adds a callback for every PDF page' do
              @callbacks << [:every_pdf_page, [], :page]
            end

            option :every_zip_page, desc: 'Adds a callback for every ZIP page' do
              @callbacks << [:every_zip_page, [], :page]
            end

            option :every_doc, desc: 'Adds a callback for every HTML/XML document' do
              @callbacks << [:every_doc, [], :doc]
            end

            option :every_html_doc, desc: 'Adds a callback for every HTML document' do
              @callbacks << [:every_html_doc, [], :doc]
            end

            option :every_xml_doc, desc: 'Adds a callback for every XML document' do
              @callbacks << [:every_xml_doc, [], :doc]
            end

            option :every_xsl_doc, desc: 'Adds a callback for every XSL document' do
              @callbacks << [:every_xsl_doc, [], :doc]
            end

            option :every_rss_doc, desc: 'Adds a callback for every RSS document' do
              @callbacks << [:every_rss_doc, [], :doc]
            end

            option :every_atom_doc, desc: 'Adds a callback for every Atom document' do
              @callbacks << [:every_atom_doc, [], :doc]
            end

            argument :file, required: true,
                            desc: 'The file to create'

            description 'Creates a new ronin-web-spider script'

            man_page 'ronin-web-new-spider.1'

            # The entry point method for the web spider agent.
            #
            # @return [Symbol, nil]
            attr_reader :entry_point_method

            # The callbacks for the web spider agent.
            #
            # @return [Array<(Symbol, Array, Symbol)>]
            attr_reader :callbacks

            #
            # Initializes the command.
            #
            # @param [Hash{Symbol => Object}] kwargs
            #   Additional keyword arguments for the command.
            #
            def initialize(**kwargs)
              super(**kwargs)

              @callbacks = []
            end

            #
            # Runs the `ronin-web new spider` command.
            #
            # @param [String] path
            #   The path to the new script file to create.
            #
            def run(path)
              unless @entry_point_method
                print_error "must specify --host, --domain, or --site"
                exit(-1)
              end

              erb 'spider.rb.erb', path
              chmod '+x', path
            end

            #
            # The entry method's argument.
            #
            # @return [String]
            #   The escaped entry point method argument or `ARGV[0]`.
            #
            def entry_point_argument
              if @entry_point_argument
                @entry_point_argument.inspect
              else
                'ARGV[0]'
              end
            end

          end
        end
      end
    end
  end
end
