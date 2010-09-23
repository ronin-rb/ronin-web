require 'ronin/web/server/base'

require 'web/server/classes/sub_app'

class TestApp < Ronin::Web::Server::Base

  get '/tests/get' do
    'block tested'
  end

  any '/tests/any' do
    'any tested'
  end

  map '/tests/subapp/', SubApp

  public_dir File.join(File.dirname(__FILE__),'public1')
  public_dir File.join(File.dirname(__FILE__),'public2')

end
