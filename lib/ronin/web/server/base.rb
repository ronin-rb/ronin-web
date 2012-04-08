#
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/web/server/helpers'
require 'ronin/ui/output'

require 'thread'
require 'rack'
require 'sinatra/base'

module Ronin
  module Web
    module Server
      #
      # The base-class for all Ronin Web Servers. Extends
      # [Sinatra::Base](http://rubydoc.info/gems/sinatra/Sinatra/Base)
      # with additional helper methods and Rack {Middleware}.
      #
      class Base < Sinatra::Base

        include Server::Helpers
        extend UI::Output::Helpers

        # Default interface to run the Web Server on
        DEFAULT_HOST = '0.0.0.0'

        # Default port to run the Web Server on
        DEFAULT_PORT = 8000

        set :host, DEFAULT_HOST
        set :port, DEFAULT_PORT

        #
        # The default Rack Handler to run all web servers with.
        #
        # @return [String]
        #   The class name of the Rack Handler to use.
        #
        # @since 0.2.0
        #
        # @api public
        #
        def Base.handler
          @@ronin_web_server_handler ||= nil
        end

        #
        # Sets the default Rack Handler to run all web servers with.
        #
        # @param [String] name
        #   The name of the handler.
        #
        # @return [String]
        #   The name of the new handler.
        #
        # @since 0.2.0
        #
        # @api public
        #
        def Base.handler=(name)
          @@ronin_web_server_handler = name
        end

        #
        # The list of Rack Handlers to attempt to use with the web server.
        #
        # @return [Array]
        #   The names of handler classes.
        #
        # @since 0.2.0
        #
        # @api public
        #
        def self.handlers
          handlers = self.server

          if Base.handler
            handlers = [Base.handler] + handlers
          end

          return handlers
        end

        #
        # Attempts to load the desired Rack Handler to run the web server
        # with.
        #
        # @return [Rack::Handler]
        #   The handler class to use to run the web server.
        #
        # @raise [StandardError]
        #   None of the handlers could be loaded.
        #
        # @since 0.2.0
        #
        # @api semipublic
        #
        def self.handler_class
          self.handlers.find do |name|
            begin
              return Rack::Handler.get(name)
            rescue Gem::LoadError => e
              raise(e)
            rescue NameError, ::LoadError
              next
            end
          end

          raise(StandardError,"unable to find any Rack handlers")
        end

        #
        # Run the web server using the Rack Handler returned by
        # {handler_class}.
        #
        # @param [Hash] options Additional options.
        #
        # @option options [String] :host
        #   The host the server will listen on.
        #
        # @option options [Integer] :port
        #   The port the server will bind to.
        #
        # @option options [Boolean] :background (false)
        #   Specifies wether the server will run in the background or run
        #   in the foreground.
        #
        # @since 0.2.0
        #
        # @api public
        #
        def self.run!(options={})
          rack_options = {
            :Host => (options[:host] || self.host),
            :Port => (options[:port] || self.port)
          }

          runner = lambda { |handler,server,options|
            print_info "Starting Web Server on #{options[:Host]}:#{options[:Port]}"
            print_debug "Using Web Server handler #{handler}"

            handler.run(server,options) do |server|
              trap(:INT) do
                # Use thins' hard #stop! if available,
                # otherwise just #stop
                server.respond_to?(:stop!) ? server.stop! : server.stop
              end

              set :running, true
            end
          }

          handler = self.handler_class

          if options[:background]
            Thread.new(handler,self,rack_options,&runner)
          else
            runner.call(handler,self,rack_options)
          end

          return self
        end

      end
    end
  end
end
