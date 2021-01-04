require 'spec_helper'
require 'ronin/web/mechanize'

describe Web::Mechanize do
  describe "#initialize" do
    describe ":user_agent" do
      before do
        Web.user_agent = 'test'
      end

      it "should default to Web.user_agent" do
        expect(described_class.new.user_agent).to eq('test')
      end

      it "should support using a custom User-Agent string" do
        agent = described_class.new(user_agent: 'test2')

        expect(agent.user_agent).to eq('test2')
      end

      it "should support using a custom User-Agent alias" do
        agent = described_class.new(user_agent_alias: 'iPhone')

        expect(agent.user_agent).to eq("Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1C28 Safari/419.3")
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

      before do
        Web.proxy = {host: 'www.example.com', port: port}
      end

      it "should default to Web.proxy" do
        agent = described_class.new

        expect(agent.proxy_addr).to eq(Web.proxy.host)
        expect(agent.proxy_port).to eq(Web.proxy.port)
      end

      it "should support using custom proxies" do
        agent = described_class.new(proxy: proxy)

        expect(agent.proxy_addr).to eq(host)
        expect(agent.proxy_port).to eq(port)
      end

      after(:all) do
        Web.proxy = nil
      end
    end
  end
end
