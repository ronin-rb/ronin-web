#
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

require 'ronin/web/middleware/helpers'
require 'ronin/web/middleware/files'
require 'ronin/web/middleware/directories'
require 'ronin/web/middleware/router'
require 'ronin/web/middleware/proxy'
require 'ronin/templates/erb'
require 'ronin/ui/output'
require 'ronin/extensions/meta'

require 'thread'
require 'rack'
require 'sinatra'

module Ronin
  module Web
    module Server
      class Base < Sinatra::Base

        include Templates::Erb
        include UI::Output::Helpers
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

          raise(StandardError,"unable to find any Rack handlers",caller)
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

        #
        # Route any type of request for a given URL pattern.
        #
        # @param [String] path
        #   The URL pattern to handle requests for.
        #
        # @yield []
        #   The block that will handle the request.
        #
        # @example
        #   any '/submit' do
        #     puts request.inspect
        #   end
        #
        # @since 0.2.0
        #
        def self.any(path,options={},&block)
          get(path,options,&block)
          put(path,options,&block)
          post(path,options,&block)
          delete(path,options,&block)
        end

        #
        # Sets the default route.
        #
        # @yield []
        #   The block that will handle all other requests.
        #
        # @example
        #   default do
        #     status 200
        #     content_type :html
        #     
        #     %{
        #     <html>
        #       <body>
        #         <center><h1>YOU LOSE THE GAME</h1></center>
        #       </body>
        #     </html>
        #     }
        #   end
        #
        # @since 0.2.0
        #
        def self.default(&block)
          class_def(:default_response,&block)
          return self
        end

        #
        # Hosts the contents of a file.
        #
        # @param [String] remote_path
        #   The path the web server will host the file at.
        #
        # @param [String] local_path
        #   The path to the local file.
        #
        # @example
        #   file '/robots.txt', '/path/to/my_robots.txt'
        #
        # @since 0.3.0
        #
        def self.file(remote_path,local_path)
          use Middleware::Files, :paths => {remote_path => local_path}
        end

        #
        # Hosts the contents of files.
        #
        # @yield [files]
        #   The given block will be passed the files middleware to
        #   configure.
        #
        # @yieldparam [Middleware::Files]
        #   The files middleware object.
        #
        # @example
        #   files do |files|
        #     files.map '/foo.txt', 'foo.txt'
        #     files.map /\.exe$/, 'trojan.exe'
        #   end
        #
        # @since 0.3.0
        #
        def self.files(&block)
          use(Middleware::Files,&block)
        end

        #
        # Hosts the contents of the directory.
        #
        # @param [String] remote_path
        #   The path the web server will host the directory at.
        #
        # @param [String] local_path
        #   The path to the local directory.
        #
        # @example
        #   directory '/download/', '/tmp/files/'
        #
        # @since 0.2.0
        #
        def self.directory(remote_path,local_path)
          use Middleware::Directories, :paths => {remote_path => local_path}
        end

        #
        # Hosts the contents of directories.
        #
        # @yield [dirs]
        #   The given block will be passed the directories middleware to
        #   configure.
        #
        # @yieldparam [Middleware::Directories]
        #   The directories middleware object.
        #
        # @example
        #   directories do |dirs|
        #     dirs.map '/downloads', '/tmp/ronin_downloads'
        #     dirs.map '/images', '/tmp/ronin_images'
        #     dirs.map '/pdfs', '/tmp/ronin_pdfs'
        #   end
        #
        # @since 0.3.0
        #
        def self.directories(&block)
          use(Middleware::Directories,&block)
        end

        #
        # Hosts the static contents within a given directory.
        #
        # @param [String] path
        #   The path to a directory to serve static content from.
        #
        # @example
        #   public_dir 'path/to/another/public'
        #
        # @since 0.2.0
        #
        def self.public_dir(path)
          self.directory('/',path)
        end

        #
        # Routes all requests within a given directory into another
        # web server.
        #
        # @param [String, Regexp] dir
        #   The directory that requests for will be routed from.
        #
        # @param [#call] server
        #   The web server to route requests to.
        #
        # @example
        #   map '/subapp/', SubApp
        #
        # @since 0.2.0
        #
        def self.map(dir,server)
          use Middleware::Router do |router|
            router.draw :path => dir, :to => server
          end
        end

        #
        # Routes requests with a specific Host header to another
        # web server.
        #
        # @param [String, Regexp] name
        #   The host-name to route requests for.
        #
        # @param [#call] server
        #   The web server to route the requests to.
        #
        # @example
        #   vhost 'cdn.evil.com', EvilServer
        #
        # @since 0.3.0
        #
        def self.vhost(name,server)
          use Middleware::Router do |router|
            router.draw :vhost => name, :to => server
          end
        end

        #
        # Proxies requests to a given path.
        #
        # @param [String] path
        #   The path to proxy requests for.
        #
        # @param [Hash] options
        #   Additional options.
        # 
        # @yield [(response), body]
        #   If a block is given, it will be passed the optional
        #   response of the proxied request and the body received
        #   from the proxied request.
        #
        # @yieldparam [Net::HTTP::Response] response
        #   The response.
        #
        # @yieldparam [String] body
        #   The body from the response.
        #
        # @example
        #   proxy '/login.php' do |response,body|
        #     body.gsub(/https/,'http')
        #   end
        #
        # @since 0.2.0
        #
        def self.proxy(path,options={},&block)
          use(Middleware::Proxy,options,&block)
        end

        protected

        #
        # Returns an HTTP 404 response with an empty body.
        #
        # @since 0.2.0
        #
        def default_response
          halt 404, ''
        end

        enable :sessions

        helpers Middleware::Helpers

        any('*') { default_response }

      end
    end
  end
end
