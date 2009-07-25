require 'spec/interop/test'
require 'rack/test'

module ServerHelpers
  include Rack::Test::Methods

  def app=(server)
    @app = server
    @app.set :environment, :test
  end

  def app
    @app
  end
end
