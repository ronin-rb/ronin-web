require 'spec_helper'
require 'ronin/web/mechanize'

describe Ronin::Web::Mechanize do
  describe "#initialize" do
    it "must disable SSL verification by default" do
      expect(subject.verify_mode).to eq(OpenSSL::SSL::VERIFY_NONE)
    end

    context "when Ronin::Support::Network::HTTP.user_agent is set" do
      let(:user_agent) { 'test' }

      before { Ronin::Support::Network::HTTP.user_agent = user_agent }

      it "should set #user_agent to Ronin::Support::Network::HTTP.user_agent" do
        expect(subject.user_agent).to eq(user_agent)
      end

      after { Ronin::Support::Network::HTTP.user_agent = nil }
    end

    context "when the :user_agent option is given" do
      context "and it's a String" do
        let(:user_agent) { 'test2' }

        subject { described_class.new(user_agent: user_agent) }

        it "should set #user_agent to the custom User-Agent string" do
          expect(subject.user_agent).to eq(user_agent)
        end
      end

      context "and it's a Symbol" do
        let(:user_agent) { :chrome_linux }
        let(:expected_user_agent) do
          Ronin::Support::Network::HTTP::UserAgents[user_agent]
        end

        subject { described_class.new(user_agent: user_agent) }

        it "should set #user_agent to the custom User-Agent alias" do
          expect(subject.user_agent).to eq(expected_user_agent)
        end
      end
    end

    let(:host)  { '127.0.0.1' }
    let(:port)  { 8080 }
    let(:proxy) { URI::HTTP.build(host: host, port: port) }

    context "when Ronin::Support::Network::HTTP.proxy is set" do
      before { Ronin::Support::Network::HTTP.proxy = proxy }

      it "should set #proxy_addr and #proxy_port to Ronin::Support::Network::HTTP.proxy" do
        expect(subject.proxy_addr).to eq(
          Ronin::Support::Network::HTTP.proxy.host
        )

        expect(subject.proxy_port).to eq(
          Ronin::Support::Network::HTTP.proxy.port
        )
      end

      after { Ronin::Support::Network::HTTP.proxy = nil }
    end

    context "when the :proxy option is given" do
      subject { described_class.new(proxy: proxy) }

      it "should set #proxy_addr and #proxy_port to the custom proxy" do
        expect(subject.proxy_addr).to eq(host)
        expect(subject.proxy_port).to eq(port)
      end
    end
  end
end
