require 'spec_helper'
require 'ronin/web/cli/commands/xml'
require_relative 'man_page_example'

describe Ronin::Web::CLI::Commands::Xml do
  include_examples "man_page"

  let(:fixtures_dir) { File.join(__dir__,'..','..','fixtures') }
  let(:xml_path)     { File.join(fixtures_dir,'file.xml') }
  let(:xml)          { File.read(xml_path) }
  let(:doc)          { Nokogiri::XML(xml) }

  describe "#option_parser" do
    before { subject.option_parser.parse(argv) }

    context "when given `--xpath XPATH`" do
      let(:xpath) { '//p' }
      let(:argv)  { ['--xpath', xpath] }

      it "must set #query to the given XPATH expression" do
        expect(subject.query).to eq(xpath)
      end
    end
  end

  describe "#run" do
    let(:xpath)    { '//tag' }
    let(:elements) { doc.search(xpath) }
    let(:argv)     { [] }

    before { subject.option_parser.parse(argv) }

    context "when given an HTML file" do
      let(:argv) { ['--xpath', xpath] }

      it "must parse the HTML file, query the elements using #query, and print the elements" do
        expected_lines  = elements.map(&:to_xml)
        expected_output = expected_lines.join($/) + $/

        expect {
          subject.run(xml_path)
        }.to output(expected_output).to_stdout
      end

      context "and when --first is given" do
        let(:argv) { ['--first', '--xpath', xpath] }

        it "must only print the first matching element" do
          expected_output = elements.first.to_xml + $/

          expect {
            subject.run(xml_path)
          }.to output(expected_output).to_stdout
        end

        context "and when --text is given" do
          let(:argv) { ['--first', '--text', '--xpath', xpath] }

          it "must print the inner text of the matching elements" do
            expected_output = elements.first.inner_text + $/

            expect {
              subject.run(xml_path)
            }.to output(expected_output).to_stdout
          end
        end
      end

      context "and when --text is given" do
        let(:argv) { ['--text', '--xpath', xpath] }

        it "must print the inner text of the matching elements" do
          expected_output = elements.inner_text + $/

          expect {
            subject.run(xml_path)
          }.to output(expected_output).to_stdout
        end
      end
    end

    context "when given an HTML file and a query argument" do
      it "must parse the HTML file, query the elements using the query, and print the elements" do
        expected_lines  = elements.map(&:to_xml)
        expected_output = expected_lines.join($/) + $/

        expect {
          subject.run(xml_path,xpath)
        }.to output(expected_output).to_stdout
      end

      context "and when --first is given" do
        let(:argv) { %w[--first] }

        it "must only print the first matching element" do
          expected_output = elements.first.to_xml + $/

          expect {
            subject.run(xml_path,xpath)
          }.to output(expected_output).to_stdout
        end

        context "and when --text is given" do
          let(:argv) { %w[--first --text] }

          it "must print the inner text of the matching elements" do
            expected_output = elements.first.inner_text + $/

            expect {
              subject.run(xml_path,xpath)
            }.to output(expected_output).to_stdout
          end
        end
      end

      context "and when --text is given" do
        let(:argv) { %w[--text] }

        it "must print the inner text of the matching elements" do
          expected_output = elements.inner_text + $/

          expect {
            subject.run(xml_path,xpath)
          }.to output(expected_output).to_stdout
        end
      end
    end

    context "when no query options or QUERY argument is given" do
      it "must print an erorr and exit with -1" do
        expect(subject).to receive(:print_error).with("must specify --xpath or an XPath argument")

        expect {
          subject.run(xml_path)
        }.to raise_error(SystemExit) do |error|
          expect(error.status).to eq(-1)
        end
      end
    end
  end

  describe "#read" do
    context "when given a file path" do
      it "must return an opened File object" do
        file = subject.read(xml_path)

        expect(file).to be_kind_of(File)
        expect(file.read).to eq(xml)
      end
    end

    context "when given a http:// URL" do
      let(:url) { 'http://example.com/' }
      let(:response_body) { xml }

      it "must call Ronin::Support::Network::HTTP.get_body with the URL" do
        expect(Ronin::Support::Network::HTTP).to receive(:get_body).with(url).and_return(response_body)

        expect(subject.read(url)).to be(response_body)
      end
    end

    context "when given a https:// URL" do
      let(:url) { 'https://example.com/' }
      let(:response_body) { xml }

      it "must call Ronin::Support::Network::HTTP.get_body with the URL" do
        expect(Ronin::Support::Network::HTTP).to receive(:get_body).with(url).and_return(response_body)

        expect(subject.read(url)).to be(response_body)
      end
    end
  end

  describe "#parse" do
    let(:xml) do
      <<~XML
        <?xml version="1.0"?>
        <root>
          <tag>foo</tag>
        </root>
      XML
    end

    it "must return a Nokogiri::XML::Document object" do
      doc = subject.parse(xml)

      expect(doc).to be_kind_of(Nokogiri::XML::Document)
      expect(doc.to_s).to eq(xml)
    end
  end
end
