require 'spec_helper'
require 'ronin/web/middleware/filters/referer_filter'

describe Web::Middleware::Filters::RefererFilter do
  subject { Web::Middleware::Filters::RefererFilter }

  let(:referer)  { 'http://www.example.com/page.html' }

  before(:each) do
    @request = mock('request')
    @request.should_receive(:referer).and_return(referer)
  end

  it "should match requests using a String" do
    filter = subject.new(referer)

    filter.match?(@request).should == true
  end

  it "should match requests using a Regexp" do
    filter = subject.new(/example\.com/)

    filter.match?(@request).should == true
  end
end
