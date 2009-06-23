require 'ronin/web/server'

require 'spec_helper'
require 'web/helpers/server'

describe Web::Server do
  before(:all) do
    @server = Web::Server.new do |server|
      server.default do |env|
        server.response('This is default.')
      end

      server.bind('/test/bind.xml') do |env|
        server.response('<secret/>', :content_type => 'text/xml')
      end

      server.paths_like(/path_patterns\/secret\./) do |env|
        server.response('No secrets here.')
      end

      server.map('/test/map') do |env|
        server.response('mapped')
      end

      server.file('/test/file.txt',File.join(WEB_SERVER_ROOT,'test.txt'))

      server.directory('/test/directory/',WEB_SERVER_ROOT)
    end

    @virtual_host = Web::Server.new do |vhost|
      vhost.bind('/test/virtual_host.xml') do |env|
        vhost.response('<virtual/>', :content_type => 'text/xml')
      end
    end

    @server.host('virtual.host.com') do |vhost|
      vhost.bind('/test/virtual_host.xml') do |env|
        vhost.response('<virtual/>', :content_type => 'text/xml')
      end
    end

    @server.hosts_like(/^virtual[0-9]\./) do |vhost|
      vhost.bind('/test/virtual_host_patterns.xml') do |env|
        vhost.response('<virtual-patterns/>', :content_type => 'text/xml')
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

  it "should find the index file for a directory" do
    dir = WEB_SERVER_ROOT

    @server.index_of(dir).should == File.join(dir,'index.html')
  end

  it "should have a default response for un-matched paths" do
    path = '/test/default'

    get_path(@server,path).body.should == ['This is default.']
  end

  it "should bind a path to a certain response" do
    path = '/test/bind.xml'

    get_path(@server,path).body.should == ['<secret/>']
  end

  it "should match paths with patterns" do
    path = '/test/path_patterns/secret.pdf'

    get_path(@server,path).body.should == ['No secrets here.']
  end

  it "should match paths to sub-directories" do
    path = '/test/map/impossible.html'

    get_path(@server,path).body.should == ['mapped']
  end

  it "should return a response for a file" do
    path = '/test/file.txt'

    get_path(@server,path).body.should == ["This is a test.\n"]
  end

  it "should return files from bound directories" do
    path = '/test/directory/test.txt'

    get_path(@server,path).body.should == ["This is a test.\n"]
  end

  it "should return the index file for a bound directory" do
    path = '/test/directory/'

    get_path(@server,path).body.should == ["Index of files.\n"]
  end

  it "should match virtual hosts" do
    url = 'http://virtual.host.com/test/virtual_host.xml'

    get_url(@server,url).body.should == ['<virtual/>']
  end

  it "should match virtual hosts with patterns" do
    url = 'http://virtual0.host.com/test/virtual_host_patterns.xml'

    get_url(@server,url).body.should == ['<virtual-patterns/>']
  end

  it "should provide access to servers via their host-names" do
    virtual_host = @server.virtual_host('virtual.host.com')
    url = 'http://virtual.host.com/test/virtual_host.xml'

    get_url(virtual_host,url).body.should == ['<virtual/>']
  end

  it "should provide access to servers via their host-names that match virtual host patterns" do
    virtual_host = @server.virtual_host('virtual1.host.com')
    url = 'http://virtual0.host.com/test/virtual_host_patterns.xml'

    get_url(virtual_host,url).body.should == ['<virtual-patterns/>']
  end
end
