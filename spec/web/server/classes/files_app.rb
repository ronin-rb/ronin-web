require 'ronin/web/server/base'

class FilesApp < Ronin::Web::Server::Base

  file '/tests/file',
       File.join(File.dirname(__FILE__),'files','file.txt')

  file '/tests/file/missing', 'should_be_missing'

  get '/tests/content_type/custom' do
    return_file File.join(File.dirname(__FILE__),'files','dir3','page.xml'),
                'text/plain'
  end

  file '/tests/content_type',
       File.join(File.dirname(__FILE__),'files','dir3','page.xml')

  directory '/tests/directory',
            File.join(File.dirname(__FILE__),'files','dir')

  directory '/tests/directory',
            File.join(File.dirname(__FILE__),'files','dir2')

  directory '/tests/directory/no_index',
            File.join(File.dirname(__FILE__),'files','dir3')

end
