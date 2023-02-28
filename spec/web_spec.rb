require 'spec_helper'
require 'ronin/web'

describe Ronin::Web do
  let(:url) { 'https://example.com/' }

  it "should have a VERSION constant" do
    expect(subject.const_defined?('VERSION')).to eq(true)
  end

  describe ".html" do
    it "should be able to parse HTML" do
      doc = subject.html(%{
        <html>
          <body>Hello</body>
        </html>
      })

      expect(doc.at('body').inner_text).to eq("Hello")
    end
  end

  describe ".build_html" do
    it "should be able to build HTML documents" do
      doc = subject.build_html do
        html {
          body {
            div { text("hello") }
          }
        }
      end

      expect(doc.to_html).to include("<html><body><div>hello</div></body></html>")
    end
  end

  describe ".xml" do
    it "should be able to parse XML" do
      doc = subject.xml(%{
        <?xml version="1.0"?>
        <root>
          <stuff>Hello</stuff>
        </root>
      })

      expect(doc.at('stuff').inner_text).to eq("Hello")
    end
  end

  describe ".build_xml" do
    it "should be able to build XML documents" do
      doc = subject.build_xml do
        root {
          stuff(name: 'bla') { text("hello") }
        }
      end

      expect(doc.to_xml).to include("<root>\n  <stuff name=\"bla\">hello</stuff>\n</root>")
    end
  end

  describe ".open" do
    describe "integration", :network do
      it "must open URLs as temporary files" do
        file = subject.open(url)

        expect(file).to be_kind_of(StringIO)
        expect(file.read).to include("Example Domain")
      end
    end

    context "when given a none-URI" do
      let(:bad_uri) { ' ' }

      it do
        expect {
          subject.open(bad_uri)
        }.to raise_error(URI::InvalidURIError)
      end
    end
  end

  describe ".agent" do
    it "must return a #{described_class}::Mechanize object" do
      expect(subject.agent).to be_kind_of(described_class::Mechanize)
    end

    it "must return the same object each time" do
      expect(subject.agent).to be(subject.agent)
    end
  end

  describe ".get", :network do
    it "should be able to get Mechanize pages" do
      page = subject.get(url)

      expect(page.class).to eq(Mechanize::Page)
      expect(page.uri).to eq(URI(url))
    end
  end

  describe ".get_body", :network do
    it "should be able to get the bodies of Mechanize pages" do
      body = subject.get_body(url)

      expect(body).to include("Example Domain")
    end
  end
end
