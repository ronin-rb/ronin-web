require 'ronin/web/server/base'

class FilesApp < Ronin::Web::Server::Base

  file '/tests/file/missing', 'should_be_missing'

  file '/tests/file',
       File.join(File.dirname(__FILE__),'files','file.txt')

  file '/tests/content_type',
       File.join(File.dirname(__FILE__),'files','page.xml')

  directory '/tests/directory',
            File.join(File.dirname(__FILE__),'files','dir')

  directory '/tests/directory',
            File.join(File.dirname(__FILE__),'files','dir2')

end
