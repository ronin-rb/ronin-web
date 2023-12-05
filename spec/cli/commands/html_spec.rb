require 'spec_helper'
require 'ronin/web/cli/commands/html'
require_relative 'man_page_example'

describe Ronin::Web::CLI::Commands::Html do
  include_examples "man_page"

  let(:fixtures_dir) { File.join(__dir__,'..','..','fixtures') }
  let(:html_path)    { File.join(fixtures_dir,'page.html') }
  let(:html)         { File.read(html_path) }

  describe "#option_parser" do
    before { subject.option_parser.parse(argv) }

    context "when given `--xpath XPATH`" do
      let(:xpath) { '//p' }
      let(:argv)  { ['--xpath', xpath] }

      it "must set #query to the given XPATH expression" do
        expect(subject.query).to eq(xpath)
      end
    end

    context "when given `--css-path CSSPath`" do
      let(:css_path) { 'p.class' }
      let(:argv)     { ['--css-path', css_path] }

      it "must set #query to the given CSSPath expression" do
        expect(subject.query).to eq(css_path)
      end
    end

    context "when given `--meta-tags`" do
      let(:argv) { ['--meta-tags'] }

      it "must set #query to '//meta'" do
        expect(subject.query).to eq('//meta')
      end
    end

    context "when given `--links`" do
      let(:argv) { ['--links'] }

      it "must set #query to '//a/@href'" do
        expect(subject.query).to eq('//a/@href')
      end
    end

    context "when given `--style`" do
      let(:argv) { ['--style'] }

      it "must set #query to '//style/text()'" do
        expect(subject.query).to eq('//style/text()')
      end
    end

    context "when given `--stylesheet-urls`" do
      let(:argv) { ['--stylesheet-urls'] }

      it "must set #query to '//link[@rel=\"stylesheet\"]/@href'" do
        expect(subject.query).to eq('//link[@rel="stylesheet"]/@href')
      end
    end

    context "when given `--javascript`" do
      let(:argv) { ['--javascript'] }

      it "must set #query to '//script/text()'" do
        expect(subject.query).to eq('//script/text()')
      end
    end

    context "when given `--javascript-urls`" do
      let(:argv) { ['--javascript-urls'] }

      it "must set #query to '//script/@src'" do
        expect(subject.query).to eq('//script/@src')
      end
    end

    context "when given `--form-urls`" do
      let(:argv) { ['--form-urls'] }

      it "must set #query to '//form/@action'" do
        expect(subject.query).to eq('//form/@action')
      end
    end

    context "when given `--urls`" do
      let(:argv) { ['--urls'] }

      it "must set #query to '//a/@href | //link/@href | //script/@src | //form/@action'" do
        expect(subject.query).to eq('//a/@href | //link/@href | //script/@src | //form/@action')
      end
    end
  end

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
