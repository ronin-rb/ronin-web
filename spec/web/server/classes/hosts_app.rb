require 'ronin/web/server/base'

class FTPApp < Ronin::Web::Server::Base

  get '/file' do
    'FTP File'
  end

end

class WWWApp < Ronin::Web::Server::Base

  get '/file' do
    'WWW File'
  end

end

class HostsApp < Ronin::Web::Server::Base

  get '/tests/for_host' do
    for_host('localhost') do
      'Admin Response'
    end

    for_host(/downloads/) do
      'Download Response'
    end

    'Generic Response'
  end

  host 'example.com', WWWApp
  hosts_like /^ftp\./, FTPApp

  get '/file' do
    'Generic File'
  end

end
