require 'spec_helper'
require 'ronin/web/middleware/rules/vhost_rule'

describe Web::Middleware::Rules::VHostRule do
  subject { Web::Middleware::Rules::VHostRule }

  before(:each) do
    @request = mock('request')
    @request.should_receive(:host).and_return('domain.example.com')
  end

  it "should match requests using a String" do
    rule = subject.new('domain.example.com')

    rule.match?(@request).should == true
  end

  it "should match requests using a Regexp" do
    rule = subject.new(/example\.com/)

    rule.match?(@request).should == true
  end
end
