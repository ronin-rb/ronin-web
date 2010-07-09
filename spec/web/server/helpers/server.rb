begin
  require 'rack/test'
rescue Gem::LoadError => e
  raise(e)
rescue ::LoadError
  STDERR.puts "Error: please install the rack-test gem in order to run the spec tests"
  exit -1
end

module Helpers
  module Web
    module Server
      include Rack::Test::Methods

      attr_reader :app

      def app=(server)
        @app = server
        @app.set :environment, :test
      end

      def get_host(path,host,params={},headers={})
        get(path,params,headers.merge('HTTP_HOST' => host))
      end

      def post_host(path,host,params={},headers={})
        post(path,params,headers.merge('HTTP_HOST' => host))
      end
    end
  end
end
