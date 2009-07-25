require 'ronin/web/server/base'

class SubApp < Ronin::Web::Server::Base

  get '/hello' do
    'SubApp greets you'
  end

  get '/' do
    'SubApp'
  end

end
