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

require 'rack'

module Ronin
  module Web
    class Server

      # Default interface to run the Web Server on
      HOST = '0.0.0.0'

      # Default port to run the Web Server on
      PORT = 8080

      # The host to bind to
      attr_accessor :host

      # The port to listen on
      attr_accessor :port

      #
      # Creates a new Web Server using the given configuration _block_.
      #
      # _options_ may contain the following keys:
      # <tt>:host</tt>:: The host to bind to, defaults to Server.default_host.
      # <tt>:port</tt>:: The port to listen on, defaults to Server.default_port.
      #
      def initialize(options={},&block)
        @host = (options[:host] || Server.default_host)
        @port = (options[:port] || Server.default_port)

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
      # Creates a new Web Server object with the given _block_ and starts it
      # using the given _options_.
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
      # Returns the HTTP 404 Not Found message for the requested path.
      #
      def not_found(env)
        path = env['PATH_INFO']

        return [404, {'Content-Type' => 'text/html'}, %{
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html>
  <head>
    <title>404 Not Found</title>
  <body>
    <h1>Not Found</h1>
    <p>The requested URL #{CGI.escapeHTML(path)} was not found on this server.</p>
    <hr>
  </body>
</html>}]
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
      def response(body=[],options={},&block)
        status = (options.delete(:status) || 200)
        headers = {}

        options.each do |name,value|
          header_name = name.to_s.split('_').map { |word|
            word.capitalize
          }.join('-')

          headers[header_name] = value.to_s
        end

        return Rack::Response.new(body,status,headers,&block)
      end

      #
      # Use the specified _block_ as the default route for all other
      # requests.
      #
      #   default do |env|
      #     [200, {'Content-Type' => 'text/html'}, 'lol train']
      #   end
      #
      def default(&block)
        @default = block
        return self
      end

      #
      # Connects the specified _server_ as a virtual host representing the
      # specified host _name_.
      #
      def connect(name,server)
        @virtual_hosts[name.to_s] = server
      end

      #
      # Registers the specified _block_ to be called when receiving requests to host
      # names which match the specified _pattern_.
      #
      #   hosts_like(/^a[0-9]\./) do
      #     map('/download/') do |env|
      #       ...
      #     end
      #   end
      #
      def hosts_like(pattern,&block)
        @virtual_host_patterns[pattern] = self.class.new(&block)
      end

      #
      # Registers the specified _block_ to be called when receiving requests for paths
      # which match the specified _pattern_.
      #
      #   paths_like(/\.xml$/) do |env|
      #     ...
      #   end
      #
      def paths_like(pattern,&block)
        @path_patterns[pattern] = block
        return self
      end

      #
      # Creates a new Server object using the specified _block_ and connects it as
      # a virtual host representing the specified host _name_.
      #
      #   host('cdn.evil.com') do
      #     ...
      #   end
      #
      def host(name,&block)
        connect(self.class.new(&block))
      end

      #
      # Binds the specified URL _path_ to the given _block_.
      #
      #   bind '/secrets.xml' do |env|
      #     [200, {'Content-Type' => 'text/xml'}, "<secrets>Made you look.</secrets>"]
      #   end
      #
      def bind(path,&block)
        @paths[path] = block
        return self
      end

      #
      # Binds the specified URL directory _path_ to the given _block_.
      #
      #   map '/downloads' do |env|
      #     [200, {'Content-Type' => 'text/xml'}, "Your somewhere inside the downloads directory"]
      #   end
      #
      def map(path,&block)
        path += '/' unless path[-1..-1] == '/'

        @directories[path] = block
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

        bind(path) do |env|
          if File.file?(file)
            [200, {'Content-Type' => content_type_for(file)}, File.new(file)]
          else
            not_found(env)
          end
        end
      end

      #
      # Mounts the contents of the specified _directory_ to the given
      # prefix _path_.
      #
      #   mount '/download/', '/tmp/files/'
      #
      def mount(path,dir)
        dir = File.expand_path(dir)

        map(path) do |env|
          http_path = File.expand_path(env['PATH_INFO'])
          sub_path = http_path.sub(path,'')
          absolute_path = File.join(dir,sub_path)

          return_file(absolute_path,env)
        end
      end

      #
      # Starts the server.
      #
      def start
        Rack::Handler::WEBrick.run(self, :Host => @host, :Port => @port)
        return self
      end

      #
      # The method which receives all requests.
      #
      def call(env)
        http_host = env['HTTP_HOST']
        http_path = File.expand_path(env['PATH_INFO'])

        if http_host
          if (server = @virtual_hosts[http_host])
            return server.call(env)
          end

          @virtual_host_patterns.each do |pattern,server|
            if http_host.match(pattern)
              return server.call(env)
            end
          end
        end

        if http_path
          if (block = @paths[http_path])
            return block.call(env)
          end

          @path_patterns.each do |pattern,block|
            if http_path.match(pattern)
              return block.call(env)
            end
          end

          sub_dir = @directories.keys.select { |path|
            http_path[0...path.length] == path
          }.sort.last

          if (sub_dir && (block = @directories[sub_dir]))
            return block.call(env)
          end
        end

        return @default.call(env)
      end

      def route(url)
        url = URI(url.to_s)

        call(
          'HTTP_HOST' => url.host,
          'HTTP_PORT' => url.port,
          'SERVER_PORT' => url.port,
          'PATH_INFO' => url.path,
          'QUERY_STRING' => url.query
        )
      end

      def route_path(path)
        path, query = URI.decode(path.to_s).split('?',2)

        route(URI::HTTP.build(
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
