require 'spec_helper'
require 'ronin/web/middleware/files'

require 'web/helpers/rack_app'
require 'web/middleware/apps/files_app'

describe Web::Middleware::Files do
  include Helpers::Web::RackApp

  before(:all) do
    self.app = FilesApp
  end

  it "should map remote files to local files" do
    get '/test'

    last_response.should be_ok
    last_response.body.should == "test1\n"
  end

  it "should match the whole remote path" do
    get '/test/sub'

    last_response.should be_ok
    last_response.body.should == "test2\n"
  end

  it "should match requests before the app" do
    get '/test/overriden'

    last_response.should be_ok
    last_response.body.should == "test3\n"
  end

  it "should still route un-matched requests to the app" do
    get '/test/other'

    last_response.should be_ok
    last_response.body.should == 'other'
  end
end
