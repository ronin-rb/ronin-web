#
#--
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

require 'ronin/web/server/helpers/rendering'
require 'ronin/web/server/helpers/proxy'
require 'ronin/web/server/files'
require 'ronin/web/server/hosts'
require 'ronin/static/finders'
require 'ronin/templates/erb'
require 'ronin/extensions/meta'

require 'set'
require 'thread'
require 'rack'
require 'sinatra'

module Ronin
  module Web
    module Server
      class Base < Sinatra::Base

        include Static::Finders
        include Rack::Utils
        include Templates::Erb

        include Files
        include Hosts

        # Default interface to run the Web Server on
        DEFAULT_HOST = '0.0.0.0'

        # Default port to run the Web Server on
        DEFAULT_PORT = 8080

        # Default list of index file-names to search for in directories
        DEFAULT_INDICES = ['index.html', 'index.htm']

        # Directory to search for views within
        VIEWS_DIR = File.join('ronin','web','server','views')

        set :host, DEFAULT_HOST
        set :port, DEFAULT_PORT

        #
        # Returns the name of the Rack Handler to run all servers under
        # by default.
        #
        def Base.handler
          @@ronin_web_server_handler ||= nil
        end

        #
        # Sets the handler, which all servers will be ran under by default,
        # to the specified _name_.
        #
        def Base.handler=(name)
          @@ronin_web_server_handler = name
        end

        #
        # Returns the set of index file-names to search for within
        # directories.
        #
        def Base.indices
          @@ronin_web_server_indices ||= Set[*DEFAULT_INDICES]
        end

        #
        # Adds specified _name_ to Base.indices.
        #
        def Base.index(name)
          Base.indices << name.to_s
        end

        #
        # Returns the Array of handlers to attempt to use when starting
        # the server.
        #
        def self.handlers
          handlers = self.server

          if Base.handler
            handlers = [Base.handler] + handlers
          end

          return handlers
        end

        #
        # Returns the Rack::Handler class to use for the web server,
        # based on the +handler+. If the +handler+ of the web server cannot
        # be found, Rack::Handler::Mongrel or Rack::Handler::WEBrick will
        # be returned instead.
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
        # Starts the server with the given _options_. Mongrel will be
        # used to run the server, if it is installed, otherwise WEBrick
        # will be used.
        #
        # _options_ may contain the following keys:
        # <tt>:host</tt>:: The host the server will listen on.
        # <tt>:port</tt>:: The port the server will bind to.
        # <tt>:background</tt>:: Specifies wether the server will
        #                        run in the background or run in
        #                        the foreground.
        #
        def self.run!(options={})
          rack_options = {
            :Host => (options[:host] || self.host),
            :Port => (options[:port] || self.port)
          }

          runner = lambda { |handler,server,options|
            handler.run(server,options) do |server|
              trap(:INT) do
                ## Use thins' hard #stop! if available, otherwise just #stop
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
        # Binds the given _block_ to any request for the specified _path_.
        #
        #   any '/submit' do
        #     puts request.inspect
        #   end
        #
        def self.any(path,options={},&block)
          get(path,options,&block)
          put(path,options,&block)
          post(path,options,&block)
          delete(path,options,&block)
        end

        #
        # Sets the default block to the given _block_.
        #
        #   default do
        #     status 200
        #     content_type :html
        #     
        #     %{
        #     <html>
        #       <body>
        #         <center><h1>YOU LOOSE THE GAME</h1></center>
        #       </body>
        #     </html>
        #     }
        #   end
        #
        def self.default(&block)
          class_def(:default_response,&block)
          return self
        end

        #
        # Maps all requests to the specified _http_path_ to the
        # specified _server_.
        #
        #   MyApp.map '/subapp/', SubApp
        #
        def self.map(http_path,server)
          http_path = File.join(http_path,'')

          before do
            if http_path == request.path_info[0,http_path.length]
              # remove the http_path from the beginning of the path
              # before passing it to the server
              request.env['PATH_INFO'] = request.path_info[http_path.length-1..-1]

              halt(*server.call(request.env))
            end
          end
        end

        #
        # Hosts the static contents within the specified _directory_.
        #
        #   MyApp.public_dir 'path/to/another/public'
        #
        def self.public_dir(directory)
          directory = File.expand_path(directory)

          before do
            sub_path = File.expand_path(File.join('',request.path_info))
            full_path = File.join(directory,sub_path)

            return_file(full_path) if File.file?(full_path)
          end
        end

        protected

        #
        # Returns an HTTP 404 response with an empty body.
        #
        def default_response
          halt 404, ''
        end

        enable :sessions

        helpers Helpers::Rendering
        helpers Helpers::Proxy

        not_found do
          default_response
        end

      end
    end
  end
end
