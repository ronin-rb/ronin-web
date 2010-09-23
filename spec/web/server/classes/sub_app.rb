require 'ronin/web/server/base'

class SubApp < Ronin::Web::Server::Base

  get '/tests/subapp/hello' do
    'SubApp greets you'
  end

  get '/tests/subapp/' do
    'SubApp'
  end

end
