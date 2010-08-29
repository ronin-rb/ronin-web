require 'spec_helper'
require 'ronin/web/middleware/filters/vhost_filter'

describe Web::Middleware::Filters::VHostFilter do
  subject { Web::Middleware::Filters::VHostFilter }

  before(:each) do
    @request = mock('request')
    @request.should_receive(:host).and_return('domain.example.com')
  end

  it "should match requests using a String" do
    filter = subject.new('domain.example.com')

    filter.match?(@request).should == true
  end

  it "should match requests using a Regexp" do
    filter = subject.new(/example\.com/)

    filter.match?(@request).should == true
  end
end
