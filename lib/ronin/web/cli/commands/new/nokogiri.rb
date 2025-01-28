# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require_relative '../../command'
require_relative '../../../root'

require 'ronin/core/cli/generator'

module Ronin
  module Web
    class CLI
      module Commands
        class New < Command
          #
          # Generates a new nokogiri Ruby script for parsing HTML/XML.
          #
          # ## Usage
          #
          #     ronin-web new nokogiri [options] FILE
          #
          # ## Options
          #
          #     -U, --url URL                    Optional URL for the script
          #     -h, --help                       Print help information
          #
          # ## Arguments
          #
          #     FILE                             The file to create
          #
          class Nokogiri < Command

            include Core::CLI::Generator

            template_dir File.join(ROOT,'data','new')

            usage '[options] FILE'

            option :url, short: '-U',
                         value: {
                           type:  String,
                           usage: 'URL'
                         },
                         desc: 'Optional URL for the script'

            argument :file, required: true,
                            desc:     'The file to create'

            description 'Generates a new nokogiri Ruby script for parsing HTML/XML'

            man_page 'ronin-web-new-nokogiri.1'

            #
            # Runs the `ronin-web new nokogiri` command.
            #
            # @param [String] path
            #   The path to the new script file to create.
            #
            def run(path)
              @url = options[:url]

              erb 'nokogiri.rb.erb', path
              chmod '+x', path
            end

          end
        end
      end
    end
  end
end
