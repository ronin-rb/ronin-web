require 'spec_helper'
require 'ronin/web/middleware/rule'

describe Web::Middleware::Rule do
  subject { Web::Middleware::Rule }

  before(:each) do
    @request = mock('request')

    @request.stub!(:host).and_return('www.example.com')
    @request.stub!(:path).and_return('/path/sub/dir')
  end

  it "should match requests by default" do
    rule = subject.new()

    rule.match?(@request).should == true
  end

  it "should match requests against all filters" do
    rule = subject.new(
      :vhost => 'www.example.com',
      :path => '/path/sub/dir'
    )

    rule.match?(@request).should == true
  end

  it "should match requests against against custom logic" do
    rule = subject.new(
      :path => '/path/sub/dir',
      :when => lambda { |request| request.host =~ /example/ }
    )

    rule.match?(@request).should == true
  end
end
