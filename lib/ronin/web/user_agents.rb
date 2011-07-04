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
      # @param [Symbol, String, Regexp] key
      #
      # @return [String, nil]
      #
      # @api public
      #
      def [](key)
        reload!

        case key
        when Symbol
          unless @user_agents.has_key?(key)
            raise(ArgumentError,"unknown User-Agent group #{key}")
          end

          strings = @user_agents[key]
          return strings.entries[rand(strings.length)]
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
