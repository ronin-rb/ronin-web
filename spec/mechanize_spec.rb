require 'spec_helper'
require 'ronin/web/mechanize'

describe Ronin::Web::Mechanize do
  describe "#initialize" do
    context "when Web.user_agent is set" do
      let(:user_agent) { 'test' }

      before { Ronin::Web.user_agent = user_agent }

      it "should set #user_agent to Web.user_agent" do
        expect(subject.user_agent).to eq(user_agent)
      end

      after { Ronin::Web.user_agent = nil }
    end

    context "when the :user_agent option is given" do
      let(:user_agent) { 'test2' }

      subject { described_class.new(user_agent: user_agent) }

      it "should set #user_agent to the custom User-Agent string" do
        expect(subject.user_agent).to eq(user_agent)
      end
    end

    context "when the :user_agent_alias option is given" do
      let(:user_agent_alias) { 'iPhone' }
      let(:expected_user_agent) do
        ::Mechanize::AGENT_ALIASES.fetch(user_agent_alias)
      end

      subject { described_class.new(user_agent_alias: user_agent_alias) }

      it "should set #user_agent to the custom User-Agent alias" do
        expect(subject.user_agent).to eq(expected_user_agent)
      end
    end

    let(:host) { '127.0.0.1' }
    let(:port) { 8080 }
    let(:proxy) do
      Ronin::Network::HTTP::Proxy.new(host: host, port: port)
    end

    context "when Web.proxy is set" do
      before do
        Ronin::Web.proxy = {host: 'www.example.com', port: port}
      end

      it "should set #proxy_addr and #proxy_port to Web.proxy" do
        expect(subject.proxy_addr).to eq(Ronin::Web.proxy.host)
        expect(subject.proxy_port).to eq(Ronin::Web.proxy.port)
      end
    end

    context "when the :proxy option is given" do
      subject { described_class.new(proxy: proxy) }

      it "should set #proxy_addr and #proxy_port to the custom proxy" do
        expect(subject.proxy_addr).to eq(host)
        expect(subject.proxy_port).to eq(port)
      end

      after { Ronin::Web.proxy = nil }
    end
  end
end
