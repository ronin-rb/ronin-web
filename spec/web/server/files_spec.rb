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

  it "should allow overriding the content_type of files" do
    get '/tests/content_type/custom'

    last_response.should be_ok
    last_response.content_type.should == 'text/plain'
  end

  it "should ignore missing files that are hosted" do
    get '/test/missing'

    last_response.should_not be_ok
  end

  it "should host the contents of a directory" do
    get '/tests/directory/file.txt'

    last_response.should be_ok
    last_response.body.should == "Another file.\n"
  end

  it "should prevent directory traversal when hosting a directory" do
    get '/test/directory/./././//..///.///..///./../files_spec.rb'

    last_response.should_not be_ok
  end

  it "should host the contents of directories that share a common path" do
    get '/tests/directory/file2.txt'

    last_response.should be_ok
    last_response.body.should == "Second file.\n"
  end

  it "should search for index files within a directory" do
    get '/tests/directory/'

    last_response.should be_ok
    last_response.body.should == "The index.\n"
  end

  it "should not return anything if there is no index file was found" do
    get '/tests/directory/no_index/'

    last_response.should_not be_ok
  end
end
