#
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-web.
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
# along with Ronin.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/web/server/request'
require 'ronin/web/server/response'
require 'ronin/web/server/routing'
require 'ronin/web/server/helpers'
require 'ronin/web/server/conditions'

require 'thread'
require 'rack'
require 'sinatra/base'

module Ronin
  module Web
    module Server
      #
      # The base-class for all Ronin Web Servers. Extends
      # [Sinatra::Base](http://rubydoc.info/gems/sinatra/Sinatra/Base)
      # with additional {Routing routing methods}, {Helpers helper methods} and
      # Sinatra {Conditions conditions}.
      #
      # ## Routing Methods
      #
      # * {Helpers::ClassMethods#any any}: registers a route that responds to
      #   `GET`, `POST`, `PUT`, `PATCH`, `DELETE` and `OPTIONS` requests.
      # * {Helpers::ClassMethods#default default}: registers the default route.
      # * {Helpers::ClassMethods#file file}: mounts a file at the given path.
      #   a given file.
      # * {Helpers::ClassMethods#files files}: monts multiple files.
      #   given paths.
      # * {Helpers::ClassMethods#directory directory}: mounts a directory at
      #   the given path.
      # * {Helpers::ClassMethods#directories directories}: mounts multiple
      #   directories.
      # * {Helpers::ClassMethods#public_dir public_dir}: mounts a directory
      #   at the root.
      # * {Helpers::ClassMethods#host host}: mounts a Rack app for the given
      #   vhost.
      # * {Helpers::ClassMethods#map map}: mounts a Rack app at the given
      #   path.
      # * {Helpers::ClassMethods#proxy proxy}: mounts a {Proxy} at an optional
      #   path.
      #
      # ## Helper Methods
      #
      # * {Helpers#h h}: escapes HTML entities.
      # * {Helpers#file file}: sends a file.
      # * {Helpers#mime_type_for mime_type_for}: returns the MIME type for the
      #   file.
      # * {Helpers#content_type_for content_type_for}: sets the `Content-Type`
      #   for the file.
      #
      # ## Routing Conditions
      #
      # * {Conditions::ClassMethods#ip_address ip_address}: filters requests
      #   based on their IP address.
      # * {Conditions::ClassMethods#host host}: filters requests based on the
      #   `Host` header.
      # * {Conditions::ClassMethods#referer referer}: filters requests based on
      #   the `Referer` header.
      # * {Conditions::ClassMethods#campaign campaign}: filters requests based
      #   on whether their IP address is targeted by a Campaign.
      #
      class Base < Sinatra::Base

        include Server::Routing
        include Server::Helpers
        include Server::Conditions

        # Default interface to run the Web Server on
        DEFAULT_HOST = '0.0.0.0'

        # Default port to run the Web Server on
        DEFAULT_PORT = 8000

        set :host, DEFAULT_HOST
        set :port, DEFAULT_PORT

        before do
          @request  = Request.new(@env)
          @response = Response.new
        end

        not_found { [404, {'Content-Type' => 'text/html'}, ['']] }

        #
        # Run the web server.
        #
        # @param [Hash] options Additional options.
        #
        # @option options [String] :host
        #   The host the server will listen on.
        #
        # @option options [Integer] :port
        #   The port the server will bind to.
        #
        # @option options [String] :server
        #   The Web Server to run on.
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
          set(options)

          handler      = detect_rack_handler
          handler_name = handler.name.gsub(/.*::/, '')

          runner = lambda { |handler,server|
            print_info "Starting Web Server on #{bind}:#{port}"
            print_debug "Using Web Server handler #{handler_name}"

            begin
              handler.run(server,Host: bind, Port: port) do |server|
                trap(:INT)  { quit!(server,handler_name) }
                trap(:TERM) { quit!(server,handler_name) }

                set :running, true
              end
            rescue Errno::EADDRINUSE => e
              print_error "Address is already in use: #{bind}:#{port}"
            end
          }

          if options[:background]
            Thread.new(handler,self,&runner)
          else
            runner.call(handler,self)
          end

          return self
        end

        #
        # Stops the web server.
        #
        # @param [#call] server
        #   The Rack Handler server.
        #
        # @param [String] handler_name
        #   The name of the handler.
        #
        # @since 0.3.0
        #
        # @api semipublic
        #
        def self.quit!(server,handler_name)
          # Use thins' hard #stop! if available, otherwise just #stop
          server.respond_to?(:stop!) ? server.stop! : server.stop

          print_info "Stopping Web Server on #{bind}:#{port}"
        end

      end
    end
  end
end
