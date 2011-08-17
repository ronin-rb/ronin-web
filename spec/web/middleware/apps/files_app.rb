require 'sinatra/base'
require 'web/helpers/root'

require 'ronin/web/middleware/files'

class FilesApp < Sinatra::Base

  extend Helpers::Web::Root

  use Ronin::Web::Middleware::Files do |files|
    files.map '/test', root_path('test1.txt')
    files.map '/test/sub', root_path('test2.txt')
    files.map '/test/overriden', root_path('test3.txt')
  end

  get '/test/overriden' do
    'should not receive this'
  end

  get '/test/other' do
    'other'
  end

end
