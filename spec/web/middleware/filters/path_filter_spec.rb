require 'spec_helper'
require 'ronin/web/middleware/filters/path_filter'

describe Web::Middleware::Filters::PathFilter do
  subject { Web::Middleware::Filters::PathFilter }

  before(:each) do
    @request = mock('request')
    @request.should_receive(:path).and_return('/path/sub/dir')
  end

  it "should match requests using an absolute path" do
    filter = subject.new('/path/sub')

    filter.match?(@request).should == true
  end

  it "should match requests using an path fragment" do
    filter = subject.new('sub/dir')

    filter.match?(@request).should == true
  end

  it "should match requests using a Regexp" do
    filter = subject.new(/\/sub\//)

    filter.match?(@request).should == true
  end
end
