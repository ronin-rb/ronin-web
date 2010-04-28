require 'spec_helper'
require 'ronin/web/web'

describe Web do
  it "should have a VERSION constant" do
    Web.const_defined?('VERSION').should == true
  end

  it "should be able to parse HTML" do
    doc = Web.html(%{
      <html>
        <body>Hello</body>
      </html>
    })

    doc.at('body').inner_text.should == "Hello"
  end

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

  it "should be able to parse XML" do
    doc = Web.html(%{
      <?xml version="1.0"?>
      <root>
        <stuff>Hello</stuff>
      </root>
    })

    doc.at('stuff').inner_text.should == "Hello"
  end

  it "should be able to build XML documents" do
    doc = Web.build_xml do
      root {
        stuff(:name => 'bla') { text("hello") }
      }
    end

    doc.to_xml.should include("<root>\n  <stuff name=\"bla\">hello</stuff>\n</root>")
  end

  it "should have a default proxy" do
    Web.proxy.should_not be_nil
  end

  it "should disable the proxy by default" do
    Web.proxy.should_not be_enabled
  end

  describe "proxy_url" do
    before(:all) do
      @uri = URI('http://www.example.com:9001')
    end

    it "should convert Network::HTTP::Proxy objects into a URI" do
      Web.proxy_url(Network::HTTP::Proxy.new(
        :host => 'www.example.com',
        :port => 9001
      )).should == @uri
    end

    it "should convert a Hash into a URI" do
      Web.proxy_url(
        :host => 'www.example.com', 
        :port => 9001
      ).should == @uri
    end

    it "should convert a String into a valid URI" do
      Web.proxy_url("www.example.com:9001").should == @uri
    end
  end

  it "should provide User-Agent aliases" do
    Web.user_agent_aliases.should_not be_empty
  end

  it "should provide a default User-Agent" do
    Web.user_agent.should be_nil
  end

  it "should allow setting of the User-Agent string using an alias" do
    Web.user_agent_alias = 'Mac FireFox'

    Web.user_agent.should == "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6"
  end

  it "should open URLs as temporary files" do
    file = Web.open('http://www.example.com/')
    
    file.read.should =~ /Example Web Page/
  end

  describe "agent" do
    after(:each) do
      Web.user_agent = nil
    end

    it "should provide Mechanize agents" do
      Web.agent.class.should == Mechanize
    end

    it "should use the Ronin User-Agent string" do
      Web.user_agent = 'test'
      Web.agent.user_agent.should == 'test'
    end

    it "should support using a custom User-Agent string" do
      agent = Web.agent(:user_agent => 'test2')

      agent.user_agent.should == 'test2'
    end

    it "should support using a custom User-Agent alias" do
      agent = Web.agent(:user_agent_alias => 'iPhone')
      
      agent.user_agent.should == "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1C28 Safari/419.3"
    end

    describe ":proxy" do
      it "should accept Proxy values" do
        pending "Mechanize needs reader methods for the proxy settings"
      end

      it "should accept Hash values" do
      end

      it "should accept String values" do
        pending "Mechanize needs reader methods for the proxy settings"
      end

      it "should default to Web.proxy" do
        pending "Mechanize needs reader methods for the proxy settings"
      end

      it "should raise a RuntimeError exception for bad :proxy options" do
        lambda {
          Web.agent(:proxy => 42)
        }.should raise_error(RuntimeError)
      end
    end
  end

  it "should be able to get Mechanize pages" do
    page = Web.get('http://www.example.com/')

    page.class.should == Mechanize::Page
    page.at('title').inner_text.should == 'Example Web Page'
  end

  it "should be able to get the bodies of Mechanize pages" do
    body = Web.get_body('http://www.example.com/')

    body.should =~ /Example Web Page/
  end
end
