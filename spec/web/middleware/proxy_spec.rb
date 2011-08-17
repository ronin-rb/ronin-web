require 'spec_helper'
require 'ronin/web/middleware/proxy'

require 'web/helpers/rack_app'
require 'web/middleware/apps/proxy_app'

describe Web::Middleware::Proxy do
  include Helpers::Web::RackApp

  before(:all) do
    self.app = ProxyApp
  end

  it "should proxy requests that match the proxies filters" do
    pending "http://github.com/brynary/rack-test/issues#issue/16" do
      get '/login'

      last_response.should be_ok
      last_response.body.should_not == 'unproxied login'
    end
  end

  it "should allow rewriting proxied requests" do
    pending "http://github.com/brynary/rack-test/issues#issue/16" do
      get '/login'

      last_response.should be_ok
      last_response.body.should include('Log in')
    end
  end

  it "should allow rewriting proxied responses" do
    pending "http://github.com/brynary/rack-test/issues#issue/16" do
      get '/login'

      last_response.should be_ok
      last_response.body.should_not include('https:')
    end
  end

  it "should still route un-matched requests to the app" do
    get '/'

    last_response.should be_ok
    last_response.body.should == 'unproxied'
  end
end
