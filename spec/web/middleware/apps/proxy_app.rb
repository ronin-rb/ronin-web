require 'sinatra/base'

require 'ronin/web/middleware/proxy'

class ProxyApp < Sinatra::Base

  use Ronin::Web::Middleware::Proxy, :path => '/login' do |proxy|
    proxy.every_request do |request|
      request.scheme = 'https'
      request.host = 'github.com'
      request.port = 443
      request.referer = 'http://github.com/login'
    end

    proxy.every_response do |response|
      response.body.each { |chunk| chunk.gsub!('https:','http:') }
    end
  end

  get '/' do
    'unproxied'
  end

  get '/login' do
    'unproxied login'
  end

end
