require 'sinatra/base'
require 'ronin/web/middleware/router'

class FakeApp < Sinatra::Base

  get '/test/1' do
    'fake'
  end

  get '/test/2' do
    'fake'
  end

end

class RouterApp < Sinatra::Base

  use Ronin::Web::Middleware::Router do |router|
    router.draw :referer => /google\.com/, :to => FakeApp

    router.draw :user_agent => /MSIE/,
                :referer => /myspace\.com/,
                :to => FakeApp
  end

  get '/test/1' do
    'real'
  end

  get '/test/2' do
    'real'
  end

end
