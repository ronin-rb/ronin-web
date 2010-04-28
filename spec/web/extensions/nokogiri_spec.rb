require 'spec_helper'
require 'ronin/web/extensions/nokogiri'

require 'nokogiri'

describe Nokogiri::HTML do
  before(:all) do
    @doc = Nokogiri::HTML(%{<html><head><title>test</title></head><body><p><b>This is a test</b> html <i>page</i>.</p></div></body></html>})

    @edited_doc = Nokogiri::HTML(%{<html><head><title>test</title></head><body><p><b>This is a test</b> html page.</p></div></body></html>})
  end

  it "should be able to test if two elements are similar" do
    elem1 = @doc.at('b')
    elem2 = @edited_doc.at('b')

    elem1.similar?(elem2).should == true
  end

  it "should be able to test if two elements are not similar" do
    elem1 = @doc.at('p').children.last
    elem2 = @edited_doc.at('b')

    elem1.similar?(elem2).should == false
  end

  it "should be able to traverse over every text node" do
    text = []

    @doc.traverse_text { |node| text << node.content }

    text.should == ['test', 'This is a test', ' html ', 'page', '.']
  end

  it "should provide a count of all sub-children" do
    @doc.total_children.should == 12
  end
end
