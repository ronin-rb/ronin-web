require 'spec/interop/test'
require 'rack/test'

module Helpers
  module Web
    module Server
      include Rack::Test::Methods

      def app=(server)
        @app = server
        @app.set :environment, :test
      end

      def app
        @app
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
