require 'ronin/web/server'

require 'spec_helper'
require 'web/server/classes/hosts_app'
require 'web/server/helpers/server'

describe Web::Server do
  describe "hosts" do
    include Helpers::Web::Server

    before(:all) do
      self.app = HostsApp
    end

    it "should allow routes to respond to specific hosts" do
      get_host '/tests/for_host', 'localhost'

      last_response.should be_ok
      last_response.body.should == 'Admin Response'
    end

    it "should allow routes to respond to hosts matching a pattern" do
      get_host '/tests/for_host', 'downloads.example.com'

      last_response.should be_ok
      last_response.body.should == 'Download Response'
    end

    it "should fallback to the normal response if the host is not recognized" do
      get '/tests/for_host'

      last_response.should be_ok
      last_response.body.should == 'Generic Response'
    end

    it "should route requests for specific hosts" do
      get_host '/file', 'example.com'

      last_response.should be_ok
      last_response.body.should == 'WWW File'
    end

    it "should route requests for hosts matching a pattern" do
      get_host '/file', 'ftp.example.com'

      last_response.should be_ok
      last_response.body.should == 'FTP File'
    end

    it "should not route requests for unrecognized hosts" do
      get '/file'

      last_response.should be_ok
      last_response.body.should == 'Generic File'
    end
  end
end
