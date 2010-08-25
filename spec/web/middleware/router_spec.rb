require 'spec_helper'
require 'ronin/web/middleware/router'

require 'web/helpers/rack_app'
require 'web/middleware/classes/routed_app'

describe Web::Middleware::Router do
  include Helpers::Web::RackApp

  before(:all) do
    self.app = Class.new(Sinatra::Base) do
      FakeApp = Class.new(Sinatra::Base) do

        get '/test/1' do
          'fake'
        end

        get '/test/2' do
          'fake'
        end

      end

      use Ronin::Web::Middleware::Router do |router|
        router.rule :referer => /google\.com/, :to => FakeApp

        router.rule :user_agent => /MSIE/,
                    :referer => /myspace\.com/,
                    :to => FakeApp
      end

      get '/test/1' do
        'real'
      end

      get '/test/2' do
        'real'
      end

    end
  end

  it "should route matched requests to other apps" do
    get '/test/1', {}, {'HTTP_REFERER' => 'http://www.google.com/'}

    last_response.should be_ok
    last_response.body.should == 'fake'
  end

  it "should not route requests that do not match all rules" do
    get '/test/2', {}, {
      'HTTP_REFERER' => 'http://www.myspace.com/',
      'HTTP_USER_AGENT' => 'Curl'
    }

    last_response.should be_ok
    last_response.body.should == 'real'
  end

  it "should still route un-matched requests to the app" do
    get '/test/1'

    last_response.should be_ok
    last_response.body.should == 'real'
  end
end
