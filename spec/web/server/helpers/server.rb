require 'spec/interop/test'
require 'rack/test'

module ServerHelpers
  def self.included(base)
    base.module_eval do
      include Rack::Test::Methods
    end
  end

  def app=(server)
    @app = server
    @app.set :environment, :test
  end

  def app
    @app
  end
end
