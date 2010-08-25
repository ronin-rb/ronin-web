require 'spec_helper'
require 'ronin/web/middleware/rules/user_agent_rule'

describe Web::Middleware::Rules::UserAgentRule do
  subject { Web::Middleware::Rules::UserAgentRule }

  let(:user_agent)  { 'Windows-RSS-Platform/1.0 (MSIE 7.0; Windows NT 5.1)' }

  before(:each) do
    @request = mock('request')
    @request.should_receive(:user_agent).and_return(user_agent)
  end

  it "should match requests using a String" do
    rule = subject.new(user_agent)

    rule.match?(@request).should == true
  end

  it "should match requests using a Regexp" do
    rule = subject.new(/(MSIE|Windows)/)

    rule.match?(@request).should == true
  end
end
