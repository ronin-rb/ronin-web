require 'spec_helper'
require 'ronin/web/mechanize'

describe Web::Mechanize do
  describe "#initialize" do
    describe ":user_agent" do
      before(:all) do
        Web.user_agent = 'test'
      end

      it "should default to Web.user_agent" do
        described_class.new.user_agent.should == 'test'
      end

      it "should support using a custom User-Agent string" do
        agent = described_class.new(user_agent: 'test2')

        agent.user_agent.should == 'test2'
      end

      it "should support using a custom User-Agent alias" do
        agent = described_class.new(user_agent_alias: 'iPhone')

        agent.user_agent.should == "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1C28 Safari/419.3"
      end

      after(:all) do
        Web.user_agent = nil
      end
    end

    describe ":proxy" do
      let(:host) { '127.0.0.1' }
      let(:port) { 8080 }
      let(:proxy) {
        Network::HTTP::Proxy.new(host: host, port: port)
      }

      before(:all) do
        Web.proxy = {host: 'www.example.com', port: port}
      end

      it "should default to Web.proxy" do
        agent = described_class.new

        agent.proxy_addr.should == Web.proxy.host
        agent.proxy_port.should == Web.proxy.port
      end

      it "should support using custom proxies" do
        agent = described_class.new(proxy: proxy)

        agent.proxy_addr.should == host
        agent.proxy_port.should == port
      end

      after(:all) do
        Web.proxy = nil
      end
    end
  end
end
