require 'sinatra/base'
require 'web/helpers/root'

require 'ronin/web/middleware/directories'

class DirectoriesApp < Sinatra::Base

  extend Helpers::Web::Root

  use Ronin::Web::Middleware::Directories do |dirs|
    dirs.map '/test', root_path('test1')
    dirs.map '/test/sub', root_path('test2')
    dirs.map '/test/overriden', root_path('test3')
    dirs.map '/', root_path
  end

  get '/test/overriden/*' do
    'should not receive this'
  end

  get '/test/other' do
    'other'
  end

end
