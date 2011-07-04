#
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Web.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/web/config'

require 'set'

module Ronin
  module Web
    #
    # Represents the set of `User-Agent` strings loaded from all
    # `data/ronin/web/user_agents.yml` files.
    #
    # ## ronin/web/user_agents.yml
    #
    # The `user_agent.yml` files are essentially YAML files listing
    # `User-Agent` strings grouped by category:
    #
    #     ---
    #     :googlebot:
    #       - "Googlebot/2.1 ( http://www.googlebot.com/bot.html)"
    #       - "Googlebot-Image/1.0 ( http://www.googlebot.com/bot.html)"
    #       - "Mediapartners-Google/2.1"
    #       - "Google-Sitemaps/1.0"
    #
    # These files can be added to Ronin Repositories or to Ronin libraries,
    # and will be loaded by the {UserAgents} objects. 
    #
    # @since 0.3.0
    #
    class UserAgents

      include Enumerable
      
      # Relative path to the User-Agents file.
      FILE = File.join('ronin','web','user_agents.yml')

      #
      # Creates a new User-Agent set.
      #
      # @api semipublic
      #
      def initialize
        @files = Set[]
        @user_agents = Hash.new { |hash,key| hash[key] = Set[] }
      end

      # 
      # The categories of `User-Agent` strings.
      #
      # @return [Array<Symbol>]
      #   The names of the categories.
      #
      # @api public
      #
      def categories
        reload!

        @user_agents.keys
      end

      #
      # Iterates over each User-Agent in the set.
      #
      # @yield [ua]
      #   The given block will be passed each User-Agent.
      #
      # @yieldparam [String] ua
      #   A User-Agent string within the set.
      #
      # @return [Enumerator]
      #   If no block is given, an Enmerator will be returned.
      #
      # @api public
      #
      def each(&block)
        return enum_for(:each) unless block_given?

        @user_agents.each do |name,strings|
          strings.each(&block)
        end
      end

      #
      # Selects a `User-Agent` string from the set.
      #
      # @param [Symbol, String, Regexp] key
      #   The User-Agents group name, sub-string or Regexp to search for.
      #
      # @return [String, nil]
      #   The matching `User-Agent` string.
      #
      # @api public
      #
      def [](key)
        reload!

        case key
        when Symbol
          if @user_agents.has_key?(key)
            strings = @user_agents[key]
            return strings.entries[rand(strings.length)]
          end
        when String
          @user_agents.each do |name,strings|
            strings.each do |string|
              return string if string.include?(key)
            end
          end

          return nil
        when Regexp
          @user_agents.each do |name,strings|
            strings.each do |string|
              return string if string =~ key
            end
          end

          return nil
        else
          raise(TypeError,"key must be a Symbol, String or Regexp")
        end
      end

      #
      # Fetches a `User-Agent` string from the set.
      #
      # @param [Symbol, String, Regexp] key
      #   The User-Agents group name, sub-string or Regexp to search for.
      #
      # @param [String] default
      #   The `User-Agent` string to default to if no match is found.
      #
      # @return [String]
      #   The matching `User-Agent` string.
      #
      # @raise [ArgumentError]
      #   No matching `User-Agent` string was found, and no default value
      #   was given.
      #
      # @api public
      #
      def fetch(key,default=nil)
        unless (string = (self[key] || default))
          raise(ArgumentError,"no User-Agent strings match #{key.inspect}")
        end

        return string
      end

      protected

      #
      # Reloads the set of User-Agents.
      #
      # @api private
      #
      def reload!
        Config.each_data_file(FILE) do |path|
          next if @files.include?(path)

          data = YAML.load_file(path)

          unless data.kind_of?(Hash)
            warn "#{path.dump} did not contain a Hash"
            next
          end

          data.each do |name,strings|
            @user_agents[name.to_sym].merge(strings)
          end
        end
      end

    end
  end
end
