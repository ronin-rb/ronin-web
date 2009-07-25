require 'ronin/web/server/base'

class ProxyApp < Ronin::Web::Server::Base

  get '/' do
    proxy
  end

  get '/reddit/erlang' do
    proxy(:host => 'www.reddit.com', :path => '/r/erlang')
  end

  get '/r/erlang' do
    proxy do |body|
      for_host(/reddit\./) do
        body.gsub(/erlang/i,'Fixed Gear Bicycle')
      end
    end
  end

end
