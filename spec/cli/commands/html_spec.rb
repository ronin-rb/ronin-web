require 'spec_helper'
require 'ronin/web/cli/commands/html'
require_relative 'man_page_example'

describe Ronin::Web::CLI::Commands::Html do
  include_examples "man_page"

  let(:fixtures_dir) { File.join(__dir__,'..','..','fixtures') }
  let(:html_path)    { File.join(fixtures_dir,'page.html') }
  let(:html)         { File.read(html_path) }
  let(:doc)          { Nokogiri::HTML(html) }

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

  describe "#run" do
    let(:xpath)    { '//p' }
    let(:elements) { doc.search(xpath) }
    let(:argv)     { [] }

    before { subject.option_parser.parse(argv) }

    context "when given an HTML file" do
      let(:argv) { ['--xpath', xpath] }

      it "must parse the HTML file, query the elements using #query, and print the elements" do
        expected_lines  = elements.map(&:to_html)
        expected_output = expected_lines.join($/) + $/

        expect {
          subject.run(html_path)
        }.to output(expected_output).to_stdout
      end

      context "and when --first is given" do
        let(:argv) { ['--first', '--xpath', xpath] }

        it "must only print the first matching element" do
          expected_output = elements.first.to_html + $/

          expect {
            subject.run(html_path)
          }.to output(expected_output).to_stdout
        end

        context "and when --text is given" do
          let(:argv) { ['--first', '--text', '--xpath', xpath] }

          it "must print the inner text of the matching elements" do
            expected_output = elements.first.inner_text + $/

            expect {
              subject.run(html_path)
            }.to output(expected_output).to_stdout
          end
        end
      end

      context "and when --text is given" do
        let(:argv) { ['--text', '--xpath', xpath] }

        it "must print the inner text of the matching elements" do
          expected_output = elements.inner_text + $/

          expect {
            subject.run(html_path)
          }.to output(expected_output).to_stdout
        end
      end
    end

    context "when given an HTML file and a query argument" do
      it "must parse the HTML file, query the elements using the query, and print the elements" do
        expected_lines  = elements.map(&:to_html)
        expected_output = expected_lines.join($/) + $/

        expect {
          subject.run(html_path,xpath)
        }.to output(expected_output).to_stdout
      end

      context "and when --first is given" do
        let(:argv) { %w[--first] }

        it "must only print the first matching element" do
          expected_output = elements.first.to_html + $/

          expect {
            subject.run(html_path,xpath)
          }.to output(expected_output).to_stdout
        end

        context "and when --text is given" do
          let(:argv) { %w[--first --text] }

          it "must print the inner text of the matching elements" do
            expected_output = elements.first.inner_text + $/

            expect {
              subject.run(html_path,xpath)
            }.to output(expected_output).to_stdout
          end
        end
      end

      context "and when --text is given" do
        let(:argv) { %w[--text] }

        it "must print the inner text of the matching elements" do
          expected_output = elements.inner_text + $/

          expect {
            subject.run(html_path,xpath)
          }.to output(expected_output).to_stdout
        end
      end
    end

    context "when no query options or QUERY argument is given" do
      it "must print an erorr and exit with -1" do
        expect(subject).to receive(:print_error).with("must specify --xpath, --css-path, or an XPath/CSS-path argument")

        expect {
          subject.run(html_path)
        }.to raise_error(SystemExit) do |error|
          expect(error.status).to eq(-1)
        end
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
