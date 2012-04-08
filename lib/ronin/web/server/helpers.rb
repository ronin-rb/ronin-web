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

require 'ronin/web/middleware/helpers'
require 'ronin/web/middleware/files'
require 'ronin/web/middleware/directories'
require 'ronin/web/middleware/router'
require 'ronin/web/middleware/proxy'
require 'ronin/templates/erb'
require 'ronin/ui/output/helpers'
require 'ronin/extensions/meta'

require 'rack/utils'
require 'sinatra/base'

module Ronin
  module Web
    module Server
      module Helpers

        include Rack::Utils
        include Sinatra::Helpers
        include Templates::Erb
        include UI::Output::Helpers

        def self.included(base)
          base.extend ClassMethods

          base.module_eval do
            enable :sessions

            any('*') { default_response }
          end
        end

        module ClassMethods
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
          # @api public
          #
          def any(path,options={},&block)
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
          # @api public
          #
          def default(&block)
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
          # @see Middleware::Files
          #
          # @since 0.3.0
          #
          # @api public
          #
          def file(remote_path,local_path)
            use Middleware::Files, {remote_path => local_path}
          end

          #
          # Hosts the contents of files.
          #
          # @param [Hash] paths
          #   The mapping of remote paths to local paths.
          #
          # @yield [files]
          #   The given block will be passed the files middleware to
          #   configure.
          #
          # @yieldparam [Middleware::Files]
          #   The files middleware object.
          #
          # @example
          #   files '/foo.txt' => 'foo.txt'
          #
          # @example
          #   files do |files|
          #     files.map '/foo.txt', 'foo.txt'
          #     files.map /\.exe$/, 'trojan.exe'
          #   end
          #
          # @see Middleware::Files
          #
          # @since 0.3.0
          #
          # @api public
          #
          def files(paths={},&block)
            use(Middleware::Files,paths,&block)
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
          # @see Middleware::Directories
          #
          # @since 0.2.0
          #
          # @api public
          #
          def directory(remote_path,local_path)
            use Middleware::Directories, {remote_path => local_path}
          end

          #
          # Hosts the contents of directories.
          #
          # @param [Hash{String,Regexp => String}] paths
          #   The mapping of remote paths to local directories.
          #
          # @yield [dirs]
          #   The given block will be passed the directories middleware to
          #   configure.
          #
          # @yieldparam [Middleware::Directories]
          #   The directories middleware object.
          #
          # @example
          #   directories '/downloads' => '/tmp/ronin_downloads'
          #
          # @example
          #   directories do |dirs|
          #     dirs.map '/downloads', '/tmp/ronin_downloads'
          #     dirs.map '/images', '/tmp/ronin_images'
          #     dirs.map '/pdfs', '/tmp/ronin_pdfs'
          #   end
          #
          # @see Middleware::Directories
          #
          # @since 0.3.0
          #
          # @api public
          #
          def directories(paths={},&block)
            use(Middleware::Directories,paths,&block)
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
          # @api public
          #
          def public_dir(path)
            directory('/',path)
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
          # @see Middleware::Router
          #
          # @since 0.2.0
          #
          # @api public
          #
          def map(dir,server)
            use(Middleware::Router) do |router|
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
          # @api public
          #
          def vhost(name,server)
            use(Middleware::Router) do |router|
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
          # @see Middleware::Proxy
          #
          # @since 0.2.0
          #
          # @api public
          #
          def proxy(path,options={},&block)
            use(Middleware::Proxy,options,&block)
          end
        end

        #
        # Returns the MIME type for a path.
        #
        # @param [String] path
        #   The path to determine the MIME type for.
        #
        # @return [String]
        #   The MIME type for the path.
        #
        # @since 0.3.0
        #
        # @api public
        #
        def mime_type_for(path)
          mime_type(File.extname(path))
        end

        #
        # Sets the `Content-Type` for the file.
        #
        # @param [String] path
        #   The path to determine the `Content-Type` for.
        #
        # @since 0.3.0
        #
        # @api public
        #
        def content_type_for(path)
          content_type mime_type_for(path)
        end

        alias h escape_html

        #
        # Returns an HTTP 404 response with an empty body.
        #
        # @since 0.2.0
        #
        # @api semipublic
        #
        def default_response
          halt 404, ''
        end

        alias file send_file

      end
    end
  end
end
