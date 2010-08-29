require 'spec_helper'
require 'ronin/web/middleware/filters/user_agent_filter'

describe Web::Middleware::Filters::UserAgentFilter do
  subject { Web::Middleware::Filters::UserAgentFilter }

  let(:user_agent)  { 'Windows-RSS-Platform/1.0 (MSIE 7.0; Windows NT 5.1)' }

  before(:each) do
    @request = mock('request')
    @request.should_receive(:user_agent).and_return(user_agent)
  end

  it "should match requests using a String" do
    filter = subject.new(user_agent)

    filter.match?(@request).should == true
  end

  it "should match requests using a Regexp" do
    filter = subject.new(/(MSIE|Windows)/)

    filter.match?(@request).should == true
  end
end
