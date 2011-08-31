require 'spec_helper'
require 'ronin/web/middleware/request'

describe Web::Middleware::Request do
  describe "#address" do
    let(:ip) { '1.2.3.4' }
    let(:port) { 1024 }

    it "should contain the IP address" do
      request = described_class.new('REMOTE_ADDR' => ip)

      request.address.should == ip
    end

    it "should contain the remote port, if available" do
      request = described_class.new('REMOTE_ADDR' => ip, 'REMOTE_PORT' => port)

      request.address.should == "#{ip}:#{port}"
    end
  end

  describe "#headers" do
    it "should HTTP-* headers" do
      request = described_class.new(
        'HTTP_FOO' => 'bar',
        'HTTP_BAR' => 'baz'
      )

      request.headers.should == {'Foo' => 'bar', 'Bar' => 'baz'}
    end
  end
end
