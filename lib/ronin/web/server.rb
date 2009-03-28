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

require 'uri'
require 'cgi'

begin
  require 'mongrel'
rescue LoadError
  require 'webrick'
end

require 'rack'

module Ronin
  module Web
    class Server

      # Default interface to run the Web Server on
      HOST = '0.0.0.0'

      # Default port to run the Web Server on
      PORT = 8080

      # Directory index files
      INDICES = ['index.htm', 'index.html']

      # The host to bind to
      attr_accessor :host

      # The port to listen on
      attr_accessor :port

      # The Hash of configurable variables for the server
      attr_reader :config

      #
      # Creates a new Web Server using the given configuration _block_.
      #
      # _options_ may contain the following keys:
      # <tt>:host</tt>:: The host to bind to.
      # <tt>:port</tt>:: The port to listen on.
      # <tt>:config</tt>:: A +Hash+ of configurable variables to be used
      #                    in responses.
      #
      def initialize(options={},&block)
        @host = options[:host]
        @port = options[:port]
        @config = {}

        if options.has_key?(:config)
          @config.merge!(options[:config])
        end

        @default = method(:not_found)

        @virtual_host_patterns = {}
        @virtual_hosts = {}

        @path_patterns = {}
        @paths = {}
        @directories = {}

        instance_eval(&block) if block
      end

      #
      # Returns the default host that the Web Server will be run on.
      #
      def Server.default_host
        @@default_host ||= HOST
      end

      #
      # Sets the default host that the Web Server will run on to the
      # specified _host_.
      #
      def Server.default_host=(host)
        @@default_host = host
      end

      #
      # Returns the default port that the Web Server will run on.
      #
      def Server.default_port
        @@default_port ||= PORT
      end

      #
      # Sets the default port the Web Server will run on to the specified
      # _port_.
      #
      def Server.default_port=(port)
        @@default_port = port
      end

      #
      # The Hash of the servers supported file extensions and their HTTP
      # Content-Types.
      #
      def Server.content_types
        @@content_types ||= {}
      end

      #
      # Registers a new content _type_ for the specified file _extensions_.
      #
      #   Server.content_type 'text/xml', ['xml', 'xsl']
      #
      def self.content_type(type,extensions)
        extensions.each { |ext| Server.content_types[ext] = type }

        return self
      end

      #
      # Runs the specified _server_ with the given _options_. Server.run
      # will use Mongrel to run the _server_, if it is installed. Otherwise
      # WEBrick will be used to run the _server_.
      #
      # _options_ can contain the following keys:
      # <tt>:host</tt>:: The host the server will bind to, defaults to
      #                  Server.default_host.
      # <tt>:port</tt>:: The port the server will listen on, defaults to
      #                  Server.default_port.
      #                  
      def Server.run(server,options={})
        rack_options = {}

        rack_options[:Host] = (options[:host] || Server.default_host)
        rack_options[:Port] = (options[:port] || Server.default_port)

        if Object.const_defined?('Mongrel')
          Rack::Handler::Mongrel.run(server,rack_options)
        else
          Rack::Handler::WEBrick.run(server,rack_options)
        end
      end

      #
      # Creates a new Web Server object with the given _block_ and starts
      # it using the given _options_.
      #
      def self.start(options={},&block)
        self.new(options,&block).start
      end

      #
      # Returns the HTTP Content-Type for the specified file _extension_.
      #
      #   content_type('html')
      #   # => "text/html"
      #
      def content_type(extension)
        Server.content_types[extension] || 'application/x-unknown-content-type'
      end

      #
      # Returns the HTTP Content-Type for the specified _file_.
      #
      #   srv.content_type_for('file.html')
      #   # => "text/html"
      #
      def content_type_for(file)
        ext = File.extname(file).downcase

        return content_type(ext[1..-1])
      end

      #
      # Returns the index file contained within the _path_ of the specified
      # directory. If no index file can be found, +nil+ will be returned.
      #
      def index_of(path)
        path = File.expand_path(path)

        INDICES.each do |name|
          index = File.join(path,name)

          return index if File.file?(index)
        end

        return nil
      end

      #
      # Returns the HTTP 404 Not Found message for the requested path.
      #
      def not_found(request)
        path = request.path_info
        body = %{<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html>
  <head>
    <title>404 Not Found</title>
  <body>
    <h1>Not Found</h1>
    <p>The requested URL #{CGI.escapeHTML(path)} was not found on this server.</p>
    <hr>
  </body>
</html>}

        return response(body, :status => 404, :content_type => 'text/html')
      end

      #
      # Returns the contents of the file at the specified _path_. If the
      # _path_ points to a directory, the directory will be searched for
      # an index file. If no index file can be found or _path_ points to a
      # non-existant file, a "404 Not Found" response will be returned.
      #
      def return_file(path,request)
        if !(File.exists?(path))
          return not_found(request)
        end

        if File.directory?(path)
          unless (path = index_of(path))
            return not_found(request)
          end
        end

        return response(File.new(path), :content_type => content_type_for(path))
      end

      #
      # Returns a Rack Response object with the specified _body_, the given
      # _options_ and the given _block_.
      #
      # _options_ may include the following keys:
      # <tt>:status</tt>:: The HTTP Response status code, defaults to 200.
      #
      #   response("<data>lol</data>", :content_type => 'text/xml')
      #
      def response(body='',options={},&block)
        status = (options.delete(:status) || 200)
        headers = {}

        options.each do |name,value|
          header_name = name.to_s.split('_').map { |word|
            word.capitalize
          }.join('-')

          headers[header_name] = value.to_s
        end

        return Rack::Response.new(body,status,headers,&block).finish
      end

      #
      # Returns the server that handles requests for the specified host
      # _name_.
      #
      def virtual_host(name)
        name = name.to_s

        if @virtual_hosts.has_key?(name)
          return @virtual_hosts[name]
        end

        @virtual_host_patterns.each do |pattern,server|
          return server if name.match(pattern)
        end

        return nil
      end

      #
      # Use the given _server_ or _block_ as the default route for all
      # other requests.
      #
      #   default do |request|
      #     [200, {'Content-Type' => 'text/html'}, 'lol train']
      #   end
      #
      def default(server=nil,&block)
        @default = (server || block)
        return self
      end

      #
      # Registers the given _server_ or _block_ to be called when receiving
      # requests to host names which match the specified _pattern_.
      #
      #   hosts_like(/^a[0-9]\./) do
      #     map('/download/') do |request|
      #       ...
      #     end
      #   end
      #
      def hosts_like(pattern,server=nil,&block)
        @virtual_host_patterns[pattern] = (server || self.class.new(&block))
      end

      #
      # Registers the given _server_ or _block_ to be called when receiving
      # requests for paths which match the specified _pattern_.
      #
      #   paths_like(/\.xml$/) do |request|
      #     ...
      #   end
      #
      def paths_like(pattern,server=nil,&block)
        @path_patterns[pattern] = (server || block)
        return self
      end

      #
      # Creates a new Server object using the specified _block_ and
      # connects it as a virtual host representing the specified host
      # _name_.
      #
      #   host('cdn.evil.com') do
      #     ...
      #   end
      #
      def host(name,server=nil,&block)
        @virtual_hosts[name.to_s] = (server || self.class.new(&block))
      end

      #
      # Binds the specified URL _path_ to the given _server_ or _block_.
      #
      #   bind '/secrets.xml' do |request|
      #     [200, {'Content-Type' => 'text/xml'}, "Made you look."]
      #   end
      #
      def bind(path,server=nil,&block)
        @paths[path] = (server || block)
        return self
      end

      #
      # Binds the specified URL directory _path_ to the given 
      # _server_ or _block_.
      #
      #   map '/downloads' do |request|
      #     response(
      #       "Your somewhere inside the downloads directory",
      #       :content_type' => 'text/xml'
      #     )
      #   end
      #
      def map(path,server=nil,&block)
        @directories[path] = (server || block)
        return self
      end

      #
      # Binds the contents of the specified _file_ to the specified URL
      # _path_, using the given _options_.
      #
      #   file '/robots.txt', '/path/to/my_robots.txt'
      #
      def file(path,file,options={})
        file = File.expand_path(file)
        content_type = (options[:content_type] || content_type_for(file))

        bind(path) do |request|
          if File.file?(file)
            return_file(file,request)
          else
            not_found(request)
          end
        end
      end

      #
      # Binds the contents of the specified _directory_ to the given
      # prefix _path_.
      #
      #   directory '/download/', '/tmp/files/'
      #
      def directory(path,directory)
        sub_dirs = path.split('/')
        directory = File.expand_path(directory)

        map(path) do |request|
          http_path = File.expand_path(request.path_info)
          http_dirs = http_path.split('/')

          sub_path = http_dirs[sub_dirs.length..-1].join('/')
          absolute_path = File.join(directory,sub_path)

          return_file(absolute_path,request)
        end
      end

      #
      # Starts the server.
      #
      def start
        Server.run(self, :host => @host, :port => @port)
        return self
      end

      #
      # The method which receives all requests.
      #
      def call(env)
        http_host = env['HTTP_HOST']
        http_path = File.expand_path(env['PATH_INFO'])
        request = Rack::Request.new(env)

        if http_host
          if (server = virtual_host(http_host))
            return server.call(request)
          end
        end

        if http_path
          if (block = @paths[http_path])
            return block.call(request)
          end

          @path_patterns.each do |pattern,block|
            if http_path.match(pattern)
              return block.call(request)
            end
          end

          http_dirs = http_path.split('/')

          sub_dir = @directories.keys.select { |path|
            dirs = path.split('/')

            http_dirs[0...dirs.length] == dirs
          }.sort.last

          if (sub_dir && (block = @directories[sub_dir]))
            return block.call(request)
          end
        end

        return @default.call(request)
      end

      #
      # Routes the specified _url_ to the call method.
      #
      def route(url)
        url = URI(url.to_s)

        return call(
          'HTTP_HOST' => url.host,
          'HTTP_PORT' => url.port,
          'SERVER_PORT' => url.port,
          'PATH_INFO' => url.path,
          'QUERY_STRING' => url.query
        )
      end

      #
      # Routes the specified _path_ to the call method.
      #
      def route_path(path)
        path, query = URI.decode(path.to_s).split('?',2)

        return route(URI::HTTP.build(
          :host => @host,
          :port => @port,
          :path => path,
          :query => query
        ))
      end

      protected

      content_type 'text/html', ['html', 'htm', 'xhtml']
      content_type 'text/css', ['css']
      content_type 'text/gif', ['gif']
      content_type 'text/jpeg', ['jpeg', 'jpg']
      content_type 'text/png', ['png']
      content_type 'image/x-icon', ['ico']
      content_type 'text/javascript', ['js']
      content_type 'text/xml', ['xml', 'xsl']
      content_type 'application/rss+xml', ['rss']
      content_type 'application/rdf+xml', ['rdf']
      content_type 'application/pdf', ['pdf']
      content_type 'application/doc', ['doc']
      content_type 'application/zip', ['zip']
      content_type 'text/plain', ['txt', 'conf', 'rb', 'py', 'h', 'c', 'hh', 'cc', 'hpp', 'cpp']

    end
  end
end
