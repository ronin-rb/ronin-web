require 'spec_helper'
require 'ronin/web/user_agents'

describe Web::UserAgents do
  it "should list the categories of User-Agent strings" do
    subject.categories.should_not be_empty
  end

  describe "#[]" do
    context "with Symbol" do
      it "should select User-Agent strings by group name" do
        subject[:ie].should_not be_nil
      end

      it "should return nil if the group exists" do
        subject[:foobarbaz].should be_nil
      end
    end

    context "with String" do
      it "should select User-Agent strings by substring" do
        subject['MSIE'].should_not be_nil
      end

      it "should return nil if no User-Agent matches the substring" do
        subject['FooBarBaz'].should be_nil
      end
    end

    context "with Regexp" do
      it "should select User-Agent strings by Regexp" do
        subject[/AppleWebKit/i].should_not be_nil
      end

      it "should return nil if no User-Agent matches the Regexp" do
        subject[/FooBarBaz/i].should be_nil
      end
    end
  end

  describe "#fetch" do
    it "should fetch a User-Agent string" do
      subject.fetch(:ie).should_not be_nil
    end

    it "should raise an ArgumentError if no match was found" do
      lambda {
        subject.fetch(:foobarbaz)
      }.should raise_error(ArgumentError)
    end

    it "should return the default value if no match was found" do
      subject.fetch(:foobarbaz,'default').should == 'default'
    end
  end
end
