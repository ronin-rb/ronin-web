require 'spec_helper'
require 'ronin/web/web'

describe Web do
 let(:url) { 'http://ronin-ruby.github.com/' }
 let(:title) { 'Ronin' }

  it "should have a VERSION constant" do
    expect(Web.const_defined?('VERSION')).to eq(true)
  end

  describe "html" do
    it "should be able to parse HTML" do
      doc = Web.html(%{
        <html>
          <body>Hello</body>
        </html>
      })

      expect(doc.at('body').inner_text).to eq("Hello")
    end
  end

  describe "build_html" do
    it "should be able to build HTML documents" do
      doc = Web.build_html do
        html {
          body {
            div { text("hello") }
          }
        }
      end

      expect(doc.to_html).to include("<html><body><div>hello</div></body></html>")
    end
  end

  describe "html" do
    it "should be able to parse XML" do
      doc = Web.html(%{
        <?xml version="1.0"?>
        <root>
          <stuff>Hello</stuff>
        </root>
      })

      expect(doc.at('stuff').inner_text).to eq("Hello")
    end
  end

  describe "build_xml" do
    it "should be able to build XML documents" do
      doc = Web.build_xml do
        root {
          stuff(name: 'bla') { text("hello") }
        }
      end

      expect(doc.to_xml).to include("<root>\n  <stuff name=\"bla\">hello</stuff>\n</root>")
    end
  end

  describe "proxy" do
    it "should have a default proxy" do
      expect(Web.proxy).not_to be_nil
    end

    it "should disable the proxy by default" do
      expect(Web.proxy).not_to be_enabled
    end
  end

  describe "user_agent_aliases" do
    it "should provide User-Agent aliases" do
      expect(Web.user_agent_aliases).not_to be_empty
    end
  end

  describe "#user_agent" do
    it "should provide a default User-Agent" do
      expect(Web.user_agent).to be_nil
    end

    it "should allow setting of the User-Agent string using an alias" do
      Web.user_agent_alias = 'Mac FireFox'

      expect(Web.user_agent).to eq("Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6")
    end

    after { Web.user_agent = nil }
  end

  describe "#open", :network do
    it "should open URLs as temporary files" do
      file = Web.open(url)

      expect(file.read).to include(title)
    end
  end

  describe "agent" do
    it "should be persistent" do
      expect(Web.agent.object_id).to eq(Web.agent.object_id)
    end
  end

  describe "get", :network do
    it "should be able to get Mechanize pages" do
      page = Web.get(url)

      expect(page.class).to eq(Mechanize::Page)
      expect(page.at('title').inner_text).to include(title)
    end
  end

  describe "get_body", :network do
    it "should be able to get the bodies of Mechanize pages" do
      body = Web.get_body(url)

      expect(body).to include(title)
    end
  end
end
