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
require 'ronin/web/server/public'
require 'ronin/web/server/files'
require 'ronin/web/server/hosts'
require 'ronin/web/server/mapper'
require 'ronin/static/finders'
require 'ronin/templates/erb'

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

        include Public
        include Files
        include Hosts
        include Mapper

        # Default interface to run the Web Server on
        DEFAULT_HOST = '0.0.0.0'

        # Default port to run the Web Server on
        DEFAULT_PORT = 8080

        # Default list of index file-names to search for in directories
        DEFAULT_INDICES = ['index.html', 'index.html']

        # Directory to search for views within
        VIEWS_DIR = File.join('ronin','web','server','views')

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
          @@ronin_web_server_indices ||= Set[]
        end

        #
        # Adds specified _name_ to Base.indices.
        #
        def Base.index(name)
          Base.indices << name.to_s
        end

        #
        # Returns the Rack::Handler class to use for the web server,
        # based on the +handler+. If the +handler+ of the web server cannot
        # be found, Rack::Handler::Mongrel or Rack::Handler::WEBrick will
        # be returned instead.
        #
        def self.handler_class
          [Base.handler, 'Thin', 'Mongrel', 'WEBrick'].compact.find do |name|
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
        def self.start(options={})
          rack_options = {
            :Host => (options[:host] || DEFAULT_HOST),
            :Port => (options[:port] || DEFAULT_PORT)
          }
          runner = lambda { |handler,server,options|
            handler.run(server,options)
          }

          if options[:background]
            Thread.new(self.handler_class,self,rack_options,&runner)
          else
            runner.call(self.handler_class,self,rack_options)
          end

          return self
        end

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
          define_method(:default_response,&block)
          return self
        end

        protected

        def default_response
          halt 404, ''
        end

        enable :sessions

        helpers Helpers::Rendering
        helpers Helpers::Proxy

        #
        # Returns the HTTP 404 Not Found message for the requested path.
        #
        not_found do
          default_response
        end

      end
    end
  end
end
