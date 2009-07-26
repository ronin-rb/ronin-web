require 'ronin/web/server/helpers/proxy'

require 'spec_helper'
require 'web/server/helpers/server'
require 'web/server/classes/proxy_app'

describe Web::Server::Helpers::Proxy do
  include Helpers::Web::Server

  before(:all) do
    self.app = ProxyApp
  end

  it "should allow the proxying of requests for certain routes" do
    get_host '/', 'www.example.com'

    last_response.should be_ok
    last_response.body.should =~ /RFC\s+2606/
  end

  it "should allow overriding the headers of proxied requests" do
    get '/reddit/erlang'

    last_response.should be_ok
    last_response.body.should =~ /Erlang/
  end

  it "should allow modification of proxied responses" do
    get_host '/r/erlang', 'www.reddit.com'

    last_response.should be_ok
    last_response.body.should_not =~ /erlang/i
    last_response.body.should =~ /Fixed Gear Bicycle/
  end

  it "should allow modification of proxied HTML documents" do
    get_host '/r/ruby', 'www.reddit.com'

    last_response.should be_ok
    last_response.body.should_not =~ /rails/i
  end

  it "should allow modification of proxied XML documents" do
    get_host '/rss.php', 'milw0rm.com'

    last_response.should be_ok
    last_response.body.should_not =~ /(XSS|SQLi|SQL\s+Injection)/i
  end
end
