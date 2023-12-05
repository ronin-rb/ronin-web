require 'spec_helper'
require 'ronin/web/cli/commands/html'
require_relative 'man_page_example'

describe Ronin::Web::CLI::Commands::Html do
  include_examples "man_page"

  let(:fixtures_dir) { File.join(__dir__,'..','..','fixtures') }
  let(:html_path)    { File.join(fixtures_dir,'page.html') }
  let(:html)         { File.read(html_path) }

  describe "#read" do
    context "when given a file path" do
      it "must return an opened File object" do
        file = subject.read(html_path)

        expect(file).to be_kind_of(File)
        expect(file.read).to eq(html)
      end
    end

    context "when given a http:// URL" do
      let(:url) { 'http://example.com/' }
      let(:response_body) { html }

      it "must call Ronin::Support::Network::HTTP.get_body with the URL" do
        expect(Ronin::Support::Network::HTTP).to receive(:get_body).with(url).and_return(response_body)

        expect(subject.read(url)).to be(response_body)
      end
    end

    context "when given a https:// URL" do
      let(:url) { 'https://example.com/' }
      let(:response_body) { html }

      it "must call Ronin::Support::Network::HTTP.get_body with the URL" do
        expect(Ronin::Support::Network::HTTP).to receive(:get_body).with(url).and_return(response_body)

        expect(subject.read(url)).to be(response_body)
      end
    end
  end

  describe "#parse" do
    let(:html) do
      <<~HTML
        <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
        <html>
          <body>
            <p>Hello World</p>
          </body>
        </html>
      HTML
    end

    it "must return a Nokogiri::HTML::Document object" do
      doc = subject.parse(html)

      expect(doc).to be_kind_of(Nokogiri::HTML::Document)
      expect(doc.to_s).to eq(html)
    end
  end
end
