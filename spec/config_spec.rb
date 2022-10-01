require 'spec_helper'
require 'ronin/web/config'

describe Ronin::Web do
  describe ".proxy" do
    it "must be nil by default" do
      expect(subject.proxy).to be(nil)
    end

    context "when the RONIN_HTTP_PROXY environment variable was set" do
      before { ENV['RONIN_HTTP_PROXY'] = 'http://example.com:8080' }

      it "must parse the RONIN_HTTP_PROXY environment variable" do
        expect(subject.proxy).to eq(URI(ENV['RONIN_HTTP_PROXY']))
      end

      after do
        subject.proxy = nil
        Ronin::Support::Network::HTTP.proxy = nil
        ENV.delete('RONIN_HTTP_PROXY')
      end
    end

    context "when the HTTP_PROXY environment variable was set" do
      before { ENV['HTTP_PROXY'] = 'http://example.com:8080' }

      it "must parse the HTTP_PROXY environment variable" do
        expect(subject.proxy).to eq(URI(ENV['HTTP_PROXY']))
      end

      after do
        subject.proxy = nil
        Ronin::Support::Network::HTTP.proxy = nil
        ENV.delete('HTTP_PROXY')
      end
    end
  end

  describe ".proxy=" do
    context "when given a URI::HTTP object" do
      let(:uri) { URI('https://user:password@example.com/') }

      before { subject.proxy = uri }

      it "must set .proxy to the URI::HTTP object" do
        expect(subject.proxy).to be(uri)
      end
    end

    context "when given a String" do
      let(:string) { 'https://user:password@example.com/' }
      let(:uri)    { URI(string) }

      before { subject.proxy = string }

      it "must set .proxy to the parsed URI::HTTP of the String" do
        expect(subject.proxy).to eq(uri)
      end
    end

    context "when given nil" do
      before do
        subject.proxy = URI('https://example.com/')
        subject.proxy = nil
      end

      it "must set .proxy to nil" do
        expect(subject.proxy).to be(nil)
      end
    end

    context "when given another object" do
      let(:new_proxy) { Object.new }

      it do
        expect {
          subject.proxy = new_proxy
        }.to raise_error(ArgumentError,"invalid proxy value (#{new_proxy.inspect}), must be either a URI::HTTP, String, or nil")
      end
    end

    after { subject.proxy = nil }
  end

  describe ".user_agent" do
    it "must be nil by default" do
      expect(subject.user_agent).to be_nil
    end
  end

  describe ".user_agent=" do
    context "when given a String" do
      let(:user_agent) { 'Foo bar' }

      before { subject.user_agent = user_agent }

      it "must set #{described_class}.user_agent" do
        expect(subject.user_agent).to eq(user_agent)
      end

      after { subject.user_agent = nil }
    end

    context "when given a Symbol" do
      let(:user_agent) { :chrome_linux }
      let(:expected_user_agent) do
        Ronin::Support::Network::HTTP::UserAgents[user_agent]
      end

      before { subject.user_agent = user_agent }

      it "must set #{described_class}.user_agent based on the given Symbol" do
        expect(subject.user_agent).to eq(expected_user_agent)
      end

      after { subject.user_agent = nil }
    end

    context "when given nil" do
      before do
        subject.user_agent = "Foo bar"
        subject.user_agent = nil
      end

      it "must clear #{described_class}.user_agent" do
        expect(subject.user_agent).to be(nil)
      end
    end
  end
end
