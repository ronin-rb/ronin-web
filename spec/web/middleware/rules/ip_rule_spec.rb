require 'spec_helper'
require 'ronin/web/middleware/rules/ip_rule'

describe Web::Middleware::Rules::IPRule do
  subject { Web::Middleware::Rules::IPRule }

  let(:ip)  { '192.168.1.42' }

  before(:each) do
    @request = mock('request')
    @request.should_receive(:ip).and_return(ip)
  end

  it "should match requests using an IPAddr" do
    rule = subject.new(ip)

    rule.match?(@request).should == true
  end

  it "should match requests using an IPAddr range" do
    rule = subject.new('192.168.1.1/24')

    rule.match?(@request).should == true
  end
end
