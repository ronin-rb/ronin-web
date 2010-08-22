require 'spec_helper'
require 'ronin/web/middleware/directories'

require 'web/helpers/rack_app'
require 'web/helpers/root'

describe Web::Middleware::Directories do
  include Helpers::Web::RackApp

  before(:all) do
    self.app = Class.new(Sinatra::Base) do
      extend Helpers::Web::Root

      use Ronin::Web::Middleware::Directories do |dirs|
        dirs.map '/test', root_path('test1')
        dirs.map '/test/sub', root_path('test2')
        dirs.map '/test/overriden', root_path('test3')
      end

      get '/test/overriden/*' do
        'should not receive this'
      end

      get '/test/other' do
        'other'
      end
    end
  end

  describe "index_names" do
    subject { Web::Middleware::Directories.index_names }

    it { should include('index.html') }
    it { should include('index.xhtml') }
    it { should include('index.htm') }
  end

  it "should map remote directories to local directories" do
    get '/test/test1.txt'

    last_response.should be_ok
    last_response.body.should == "test1\n"
  end

  it "should map remote directories to index files in local directories" do
    get '/test/'

    last_response.should be_ok
    last_response.body.should == "index1\n"
  end

  it "should pass the request to the app if no index file exists" do
    get '/test/sub/'

    last_response.should_not be_ok
  end

  it "should match the whole remote path" do
    get '/test/sub/test2.txt'

    last_response.should be_ok
    last_response.body.should == "test2\n"
  end

  it "should match requests before the app" do
    get '/test/overriden/test3.txt'

    last_response.should be_ok
    last_response.body.should == "test3\n"
  end

  it "should still route un-matched requests to the app" do
    get '/test/other'

    last_response.should be_ok
    last_response.body.should == 'other'
  end
end
