require 'ronin/web/server/files'
require 'ronin/web/server/base'

require 'spec_helper'
require 'web/server/helpers/server'
require 'web/server/classes/files_app'

describe Web::Server::Files do
  include ServerHelpers

  before(:all) do
    self.app = FilesApp
  end

  it "should host individual files" do
    get '/tests/file'

    last_response.should be_ok
    last_response.body.should == "A file.\n"
  end

  it "should automatically set the content_type for files" do
    get '/tests/content_type'

    last_response.should be_ok
    last_response.content_type.should =~ /\/xml$/
  end

  it "should host the contents of a directory" do
    get '/tests/directory/file.txt'

    last_response.should be_ok
    last_response.body.should == "Another file.\n"
  end

  it "should host the contents of directories at a common path" do
    get '/tests/directory/file2.txt'

    last_response.should be_ok
    last_response.body.should == "Second file.\n"
  end

  it "should search for index files within a directory" do
    get '/tests/directory/'

    last_response.should be_ok
    last_response.body.should == "The index.\n"
  end
end
