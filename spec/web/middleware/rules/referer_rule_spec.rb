require 'spec_helper'
require 'ronin/web/middleware/rules/referer_rule'

describe Web::Middleware::Rules::RefererRule do
  subject { Web::Middleware::Rules::RefererRule }

  let(:referer)  { 'http://www.example.com/page.html' }

  before(:each) do
    @request = mock('request')
    @request.should_receive(:referer).and_return(referer)
  end

  it "should match requests using a String" do
    rule = subject.new(referer)

    rule.match?(@request).should == true
  end

  it "should match requests using a Regexp" do
    rule = subject.new(/example\.com/)

    rule.match?(@request).should == true
  end
end
