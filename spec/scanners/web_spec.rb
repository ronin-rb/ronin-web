require 'ronin/scanners/web'

require 'spec_helper'

describe Scanners::Web do
  before(:all) do
    Scanners::Web.class_eval do
      scanner(:test) do |page,results,options|
        results.call(page.url)
      end
    end

    @scanner = Scanners::Web.new(
      :host => 'www.example.com',
      :queue => 'http://www.example.com/'
    )
  end

  it "should spider every page on a website" do
    @scanner.scan.should == {:test => [URI('http://www.example.com/')]}
  end
end
