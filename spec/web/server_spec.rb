require 'ronin/web/server'

require 'spec_helper'
require 'helpers/web/server'

describe Web::Server do
  before(:all) do
    @server = Web::Server.new do
      default do |env|
        response('lol')
      end

      bind('/stuff/secret.xml') do |env|
        response('<secret/>', :headers => {'Content-Type' => 'text/xml'})
      end

      paths_like(/stuff\/secret\./) do |env|
        response('No secrets here.')
      end

      map('/stuff') do |env|
        response('stuff')
      end
    end
  end

  it "should have a default host to listen on" do
    Web::Server.default_host.should_not be_nil
  end

  it "should have a default port to listen on" do
    Web::Server.default_port.should_not be_nil
  end

  it "should have built-in content types" do
    Web::Server.content_types.should_not be_empty
  end

  it "should map file extensions to content-types" do
    @server.content_type('html').should == 'text/html'
  end

  it "should have a default content-type for unknown files" do
    @server.content_type('lol').should == 'application/x-unknown-content-type'
  end

  it "should have a default response for un-matched paths" do
    web_server_get(@server,'/imposible').body.should == ['lol']
  end

  it "should bind a path to a certain response" do
    web_server_get(@server,'/stuff/secret.xml').body.should == ['<secret/>']
  end

  it "should match paths with patterns" do
    web_server_get(@server,'/stuff/secret.pdf').body.should == ['No secrets here.']
  end

  it "should match paths to sub-directories" do
    web_server_get(@server,'/stuff/impossible.html').body.should == ['stuff']
  end
end
