require 'spec_helper'
require 'ronin/web/cli/commands/html'
require_relative 'man_page_example'

describe Ronin::Web::CLI::Commands::Html do
  include_examples "man_page"

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
