require 'rack/test'

module Helpers
  module Web
    module RackApp
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
