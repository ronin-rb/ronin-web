require 'spec_helper'
require 'ronin/web/middleware/filters/ip_filter'

describe Web::Middleware::Filters::IPFilter do
  subject { Web::Middleware::Filters::IPFilter }

  let(:ip)  { '192.168.1.42' }

  before(:each) do
    @request = mock('request')
    @request.should_receive(:ip).and_return(ip)
  end

  it "should match requests using an IPAddr" do
    filter = subject.new(ip)

    filter.match?(@request).should == true
  end

  it "should match requests using an IPAddr range" do
    filter = subject.new('192.168.1.1/24')

    filter.match?(@request).should == true
  end
end
