require 'spec_helper'
require 'ronin/web/middleware/response'

describe Web::Middleware::Response do
  subject do
    Web::Middleware::Response.new(
      ['Hello'],
      200,
      {'Content-Type' => 'text/html'}
    )
  end

  it "should allow implicit splatting" do
    status, headers, body = subject

    status.should == 200
    headers['Content-Type'].should == 'text/html'
    body.should == subject
  end
end
