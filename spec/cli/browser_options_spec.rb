require 'spec_helper'
require 'ronin/web/cli/browser_options'
require 'ronin/web/cli/command'

describe Ronin::Web::CLI::BrowserOptions do
  module TestBrowserOptions
    class Command < Ronin::Web::CLI::Command
      include Ronin::Web::CLI::BrowserOptions
    end
  end

  let(:command_class) { TestBrowserOptions::Command }
  subject { command_class.new }

  describe ".included" do
    subject { command_class }

    it "must add the '-B,--browser' option" do
      expect(subject.options[:browser]).to_not be(nil)
      expect(subject.options[:browser].short).to eq('-B')
      expect(subject.options[:browser].value.type).to be(String)
      expect(subject.options[:browser].value.usage).to eq('NAME|PATH')
      expect(subject.options[:browser].desc).to eq('The browser name or path to execute')
    end

    it "must add the '-W,--browser-width' option" do
      expect(subject.options[:width]).to_not be(nil)
      expect(subject.options[:width].short).to eq('-W')
      expect(subject.options[:width].value.type).to be(Integer)
      expect(subject.options[:width].value.default).to eq(1024)
      expect(subject.options[:width].value.usage).to eq('WIDTH')
      expect(subject.options[:width].desc).to eq('Sets the width of the browser viewport (Default: 1024)')
    end

    it "must add the '-H,--browser-height' option" do
      expect(subject.options[:height]).to_not be(nil)
      expect(subject.options[:height].short).to eq('-H')
      expect(subject.options[:height].value.type).to be(Integer)
      expect(subject.options[:height].value.default).to eq(768)
      expect(subject.options[:height].value.usage).to eq('HEIGHT')
      expect(subject.options[:height].desc).to eq('Sets the height of the browser viewport (Default: 768)')
    end
  end

  describe "#browser" do
    it "must return a Ronin::Web::Browser::Agent object" do
      expect(subject.browser).to be_kind_of(Ronin::Web::Browser::Agent)
    end

    it "must memoize the object" do
      expect(subject.browser).to be(subject.browser)
    end
  end

  describe "#browser_kwargs" do
    it "must return `{window_size: [1024, 768]}` by default" do
      expect(subject.browser_kwargs).to eq(
        {
          window_size: [1024, 768]
        }
      )
    end

    context "when the --browser-width option is given" do
      let(:new_width) { 512 }

      before { subject.options[:width] = new_width }

      it "must change the width in the :window_size keyword argument" do
        expect(subject.browser_kwargs[:window_size][0]).to eq(new_width)
      end
    end

    context "when the --browser-height option is given" do
      let(:new_height) { 512 }

      before { subject.options[:height] = new_height }

      it "must change the :height in the :window_size keyword argument" do
        expect(subject.browser_kwargs[:window_size][1]).to eq(new_height)
      end
    end

    context "when the --browser option is given" do
      let(:new_browser) { 'chromium-browser' }

      before { subject.options[:browser] = new_browser }

      it "must set the :browser_path keyword argument" do
        expect(subject.browser_kwargs[:browser_path]).to eq(new_browser)
      end
    end
  end
end
