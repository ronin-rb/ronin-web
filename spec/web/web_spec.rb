require 'spec_helper'
require 'ronin/web/web'

describe Web do
 let(:url) { 'http://ronin-ruby.github.com/' }
 let(:title) { 'Ronin' }

  it "should have a VERSION constant" do
    Web.const_defined?('VERSION').should == true
  end

  describe "html" do
    it "should be able to parse HTML" do
      doc = Web.html(%{
        <html>
          <body>Hello</body>
        </html>
      })

      doc.at('body').inner_text.should == "Hello"
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

      doc.to_html.should include("<html><body><div>hello</div></body></html>")
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

      doc.at('stuff').inner_text.should == "Hello"
    end
  end

  describe "build_xml" do
    it "should be able to build XML documents" do
      doc = Web.build_xml do
        root {
          stuff(name: 'bla') { text("hello") }
        }
      end

      doc.to_xml.should include("<root>\n  <stuff name=\"bla\">hello</stuff>\n</root>")
    end
  end

  describe "proxy" do
    it "should have a default proxy" do
      Web.proxy.should_not be_nil
    end

    it "should disable the proxy by default" do
      Web.proxy.should_not be_enabled
    end
  end

  describe "user_agent_aliases" do
    it "should provide User-Agent aliases" do
      Web.user_agent_aliases.should_not be_empty
    end
  end

  describe "#user_agent" do
    it "should provide a default User-Agent" do
      Web.user_agent.should be_nil
    end

    it "should allow setting of the User-Agent string using an alias" do
      Web.user_agent_alias = 'Mac FireFox'

      Web.user_agent.should == "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6"
    end

    after { Web.user_agent = nil }
  end

  describe "#open", :network do
    it "should open URLs as temporary files" do
      file = Web.open(url)

      file.read.should include(title)
    end
  end

  describe "agent" do
    it "should be persistent" do
      Web.agent.object_id.should == Web.agent.object_id
    end
  end

  describe "get", :network do
    it "should be able to get Mechanize pages" do
      page = Web.get(url)

      page.class.should == Mechanize::Page
      page.at('title').inner_text.should include(title)
    end
  end

  describe "get_body", :network do
    it "should be able to get the bodies of Mechanize pages" do
      body = Web.get_body(url)

      body.should include(title)
    end
  end
end
