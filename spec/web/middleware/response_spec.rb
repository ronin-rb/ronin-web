require 'spec_helper'
require 'ronin/web/middleware/response'

describe Web::Middleware::Response do
  before(:each) do
    @response = Web::Middleware::Response.new(
      200,
      {'Content-Type' => 'text/html'},
      ['Hello']
    )
  end

  it "should have a status methods" do
    @response.status.should == 200

    @response.status = 300
    @response.status.should == 300
  end

  it "should have headers methods" do
    @response.headers.should == {'Content-Type' => 'text/html'}

    @response.headers = {}
    @response.headers.should == {}
  end

  it "should have body methods" do
    @response.body.should == ['Hello']

    @response.body = ['Wow']
    @response.body.should == ['Wow']
  end

  it "should provide access to members" do
    @response[:status].should == 200

    @response[:status] = 300
    @response[:status].should == 300
  end

  it "should provide Array access to members" do
    @response[0].should == 200

    @response[0] = 300
    @response[0].should == 300
  end

  it "should provide member-like access to headers" do
    @response[:content_type].should == 'text/html'

    @response[:content_type] = 'text/txt'
    @response[:content_type].should == 'text/txt'
  end

  it "should provide method access to headers" do
    @response.content_type.should == 'text/html'

    @response.content_type = 'text/txt'
    @response.content_type.should == 'text/txt'
  end
end
