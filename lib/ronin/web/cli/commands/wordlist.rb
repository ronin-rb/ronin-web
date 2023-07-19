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
require 'ronin/web/cli/spider_options'
require 'ronin/core/cli/logging'

require 'wordlist/builder'
require 'nokogiri'

module Ronin
  module Web
    class CLI
      module Commands
        #
        # Builds a wordlist by spidering a website.
        #
        # ## Usage
        #
        #     ronin-web wordlist [options] {--host HOST | --domain DOMAIN | --site URL}
        #
        # ## Options
        #
        #         --open-timeout SECS          Sets the connection open timeout
        #         --read-timeout SECS          Sets the read timeout
        #         --ssl-timeout SECS           Sets the SSL connection timeout
        #         --continue-timeout SECS      Sets the continue timeout
        #         --keep-alive-timeout SECS    Sets the connection keep alive timeout
        #     -P, --proxy PROXY                Sets the proxy to use
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
        #     -o, --output PATH                The wordlist to write to
        #     -X, --content-xpath XPATH        The XPath for the content (Default: //body)
        #     -C, --content-css-path XPATH     The XPath for the content
        #         --meta-tags                  Parse certain meta-tags (Default: enabled)
        #         --no-meta-tags               Ignore meta-tags
        #         --alt-tags                   Parse alt-tags on images (Default: enabled)
        #         --no-alt-tags                Also parse alt-tags on images
        #         --paths                      Also parse URL paths
        #         --query-params-names         Also parse URL query param names
        #         --query-param-values         Also parse URL query param values
        #         --only-paths                 Only build a wordlist based on the paths
        #         --only-query-param           Only build a wordlist based on the query param names
        #         --only-query-param-values    Only build a wordlist based on the query param values
        #     -f, --format txt|gz|bzip2|xz     Specifies the format of the wordlist file
        #     -A, --append                     Append new words to the wordlist file intead of overwriting the file
        #     -L, --lang LANG                  The language of the text to parse
        #         --stop-word WORD             A stop-word to ignore
        #         --only-query-param-values    Only build a wordlist based on the query param values
        #     -f, --format txt|gz|bzip2|xz     Specifies the format of the wordlist file
        #     -A, --append                     Append new words to the wordlist file intead of overwriting the file
        #     -L, --lang LANG                  The language of the text to parse
        #         --stop-word WORD             A stop-word to ignore
        #         --ignore-word WORD           Ignores the word
        #         --digits                     Accepts words containing digits (Default: enabled)
        #         --no-digits                  Ignores words containing digits
        #         --special-char CHAR          Allows a special character within a word (Default: _, -, ')
        #         --numbers                    Accepts numbers as words (Default: disabled)
        #         --no-numbers                 Ignores numbers
        #         --acronyms                   Treats acronyms as words (Default: enabled)
        #         --no-acronyms                Ignores acronyms
        #         --normalize-case             Converts all words to lowercase
        #         --no-normalize-case          Preserve the case of words and letters (Default: enabled)
        #         --normalize-apostrophes      Removes apostrophes from words
        #         --no-normalize-apostrophes   Preserve apostrophes from words (Default: enabled)
        #         --normalize-acronyms         Removes '.' characters from acronyms
        #         --no-normalize-acronyms      Preserve '.' characters in acronyms (Default: enabled)
        #     -h, --help                       Print help information
        #
        class Wordlist < Command

          include Core::CLI::Logging
          include SpiderOptions

          option :output, short: '-o',
                          value: {
                            type:  String,
                            usage: 'PATH'
                          },
                          desc: 'The wordlist to write to'

          option :content_xpath, short: '-X',
                                 value: {
                                   type:   String,
                                    usage: 'XPATH'
                                 },
                                 desc: 'The XPath for the content. (Default: //body)' do |xpath|
                                   @content_xpath = xpath
                                 end

          option :content_css_path, short: '-C',
                                    value: {
                                      type:   String,
                                      usage: 'CSS-path'
                                    },
                                    desc: 'The XPath for the content' do |css_path|
                                      @content_xpath = Nokogiri::CSS.xpath_for(css_path).first
                                    end

          option :meta_tags, desc: 'Parse certain meta-tags (Default: enabled)' do
            @parse_meta_tags = true
          end
          option :no_meta_tags, desc: 'Ignore meta-tags' do
            @parse_meta_tags = false
          end

          option :comments, desc: 'Parse HTML comments (Default: enabled)' do
            @parse_comments = true
          end
          option :no_comments, desc: 'Ignore HTML comments' do
            @parse_comments = false
          end

          option :alt_tags, desc: 'Parse alt-tags on images (Default: enabled)' do
            @parse_alt_tags = true
          end
          option :no_alt_tags, desc: 'Ignore alt-tags on images' do
            @parse_alt_tags = false
          end

          option :paths, desc: 'Also parse URL paths'
          option :query_params_names, desc: 'Also parse URL query param names'
          option :query_param_values, desc: 'Also parse URL query param values'

          option :only_paths, desc: 'Only build a wordlist based on the paths'
          option :only_query_param, desc: 'Only build a wordlist based on the query param names'
          option :only_query_param_values, desc: 'Only build a wordlist based on the query param values'

          option :format, short: '-f',
                          value: {
                            type: [:txt, :gz, :bzip2, :xz]
                          },
                          desc: 'Specifies the format of the wordlist file'

          option :append, short: '-A',
                          desc: 'Append new words to the wordlist file intead of overwriting the file'

          option :lang, short: '-L',
                        value: {
                          type:  String,
                          usage: 'LANG'
                        },
                        desc: 'The language of the text to parse' do |lang|
                          options[:lang] = lang.to_sym
                        end

          option :stop_word, value: {
                               type: String,
                               usage: 'WORD'
                             },
                             desc: 'A stop-word to ignore' do |word|
                               @stop_words << word
                             end

          option :ignore_word, value: {
                                 type: String,
                                 usage: 'WORD'
                               },
                               desc: 'Ignores the word' do |word|
                                 @ignore_words << word
                               end

          option :digits, desc: 'Accepts words containing digits (Default: enabled)'
          option :no_digits, desc: 'Ignores words containing digits' do
            options[:digits] = false
          end

          option :special_char, value: {
                                  type:  String,
                                  usage: 'CHAR'
                                },
                                desc: 'Allows a special character within a word (Default: _, -, \')' do |char|
                                  @special_chars << char
                                end

          option :numbers, desc: 'Accepts numbers as words (Default: disabled)'
          option :no_numbers, desc: 'Ignores numbers' do
            options[:numbers] = false
          end

          option :acronyms, desc: 'Treats acronyms as words (Default: enabled)'
          option :no_acronyms, desc: 'Ignores acronyms' do
            options[:acronyms] = false
          end

          option :normalize_case, desc: 'Converts all words to lowercase'
          option :no_normalize_case, desc: 'Preserve the case of words and letters (Default: enabled)' do
            options[:normalize_case] = false
          end

          option :normalize_apostrophes, desc: 'Removes apostrophes from words'
          option :no_normalize_apostrophes, desc: 'Preserve apostrophes from words (Default: enabled)' do
            options[:normalize_apostrophes] = false
          end

          option :normalize_acronyms, desc: "Removes '.' characters from acronyms"
          option :no_normalize_acronyms, desc: "Preserve '.' characters in acronyms (Default: enabled)" do
            options[:no_normalize_acronyms] = false
          end

          description "Builds a wordlist by spidering a website"

          man_page 'ronin-web-wordlist.1'

          # The XPath or CSS-path for the page's content.
          #
          # @return [String]
          attr_reader :content_xpath

          # List of stop-words to ignore.
          #
          # @return [Array<String>]
          attr_reader :stop_words

          # List of words to ignore.
          #
          # @return [Array<String>]
          attr_reader :ignore_words

          # The list of special characters to allow in words.
          #
          # @return [Array<String>]
          attr_reader :special_chars

          #
          # Initializes the `ronin-web wordlist` command.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for the command.
          #
          def initialize(**kwargs)
            super(**kwargs)

            @content_xpath = nil

            @parse_meta_tags = true
            @parse_comments  = true
            @parse_alt_tags  = true

            @stop_words    = []
            @ignore_words  = []
            @special_chars = []
          end

          # XPath to find `description` and `keywords` `meta`-tags.
          META_TAGS_XPATH = '/head/meta[@name="description" or @name="keywords"]/@content'

          # XPath to find all text elements.
          TEXT_XPATH = '//text()[not (ancestor-or-self::script or ancestor-or-self::style)]'

          # XPath to find all HTML comments.
          COMMENT_XPATH = '//comment()'

          # XPath which finds all image `alt`-tags, SVG `desc` elements, and `a`
          # `title` attributes.
          ALT_TAGS_XPATH = '//img/@alt|//area/@alt|//input/@alt|//a/@title'

          #
          # Runs the `ronin-web wordlist` command.
          #
          def run
            @wordlist = ::Wordlist::Builder.new(wordlist_path,**wordlist_builder_kwargs)

            @xpath = "#{@content_xpath}#{TEXT_XPATH}"
            @xpath << "|#{META_TAGS_XPATH}"                 if @parse_meta_tags
            @xpath << "|#{@content_xpath}#{COMMENT_XPATH}"  if @parse_comments
            @xpath << "|#{@content_xpath}#{ALT_TAGS_XPATH}" if @parse_alt_tags

            begin
              new_agent do |agent|
                if options[:only_paths]
                  agent.every_url(&method(:parse_url_path))
                elsif options[:only_query_param_names]
                  agent.every_url(&method(:parse_url_query_param_names))
                elsif options[:only_query_param_values]
                  agent.every_url(&method(:parse_url_query_param_values))
                else
                  agent.every_url(&method(:parse_url_path)) if options[:paths]

                  agent.every_url(&method(:parse_url_query_param_names)) if options[:query_param_names]
                  agent.every_url(&method(:parse_url_query_param_values)) if options[:query_param_values]

                  agent.every_ok_page(&method(:parse_page))
                end
              end
            ensure
              @wordlist.close
            end
          end

          #
          # The wordlist output path.
          #
          # @return [String]
          #
          def wordlist_path
            options.fetch(:output) { infer_wordlist_path }
          end

          #
          # Generates the wordlist output path based on the `--host`,
          # `--domain`, or `--site` options.
          #
          # @return [String]
          #   The generated wordlist output path.
          #
          def infer_wordlist_path
            if    options[:host]   then "#{options[:host]}.txt"
            elsif options[:domain] then "#{options[:domain]}.txt"
            elsif options[:site]
              uri = URI.parse(options[:site])

              unless uri.port == uri.default_port
                "#{uri.host}:#{uri.port}.txt"
              else
                "#{uri.host}.txt"
              end
            else
              print_error "must specify --host, --domain, or --site"
              exit(1)
            end
          end

          # List of command `options` that directly map to the keyword arguments
          # of `Wordlist::Builder.new`.
          WORDLIST_BUILDER_OPTIONS = [
            :format,
            :append,
            :lang,
            :digits,
            :numbers,
            :acronyms,
            :normalize_case,
            :normalize_apostrophes,
            :normalize_acronyms
          ]

          #
          # Creates a keyword arguments `Hash` of all command `options` that
          # will be directly passed to `Wordlist::Builder.new`
          #
          def wordlist_builder_kwargs
            kwargs = {}

            WORDLIST_BUILDER_OPTIONS.each do |key|
              kwargs[key] = options[key] if options.has_key?(key)
            end

            kwargs[:stop_words]    = @stop_words    unless @stop_words.empty?
            kwargs[:ignore_words]  = @ignore_words  unless @ignore_words.empty?
            kwargs[:special_chars] = @special_chars unless @special_chars.empty?

            return kwargs
          end

          #
          # Parses the URL's directory names of a spidered page and adds them to
          # the wordlist.
          #
          # @param [URI::HTTP] url
          #   A spidered URL.
          #
          def parse_url_path(url)
            log_info "Parsing #{url} ..."

            url.path.split('/').each do |dirname|
              @wordlist.add(dirname) unless dirname.empty?
            end
          end

          #
          # Parses the URL's query param names of a spidered page and adds them
          # to the wordlist.
          #
          # @param [URI::HTTP] url
          #   A spidered URL.
          #
          def parse_url_query_param_names(url)
            unless url.query_params.empty?
              log_info "Parsing query param for #{url} ..."
              @wordlist.append(url.query_params.keys)
            end
          end

          #
          # Parses the URL's query param values of a spidered page and adds them
          # to the wordlist.
          #
          # @param [URI::HTTP] url
          #   A spidered URL.
          #
          def parse_url_query_param_values(url)
            unless url.query_params.empty?
              log_info "Parsing query param values for #{url} ..."

              url.query_params.each_value do |value|
                @wordlist.add(value)
              end
            end
          end

          #
          # Parses the spidered page's content and adds the words to the
          # wordlist.
          #
          # @param [Spidr::Page] page
          #   A spidered page.
          #
          def parse_page(page)
            if page.html?
              log_info "Parsing HTML on #{page.url} ..."
              parse_html(page)
            end
          end

          #
          # Parses the spidered page's HTML and adds the words to the
          # wordlist.
          #
          # @param [Spidr::Page] page
          #   A spidered page.
          #
          def parse_html(page)
            page.search(@xpath).each do |node|
              text = node.inner_text
              text.strip!

              @wordlist.parse(text) unless text.empty?
            end
          end

        end
      end
    end
  end
end
