require 'spec_helper'
require 'ronin/web/user_agents'

describe Web::UserAgents do
  it "should list the categories of User-Agent strings" do
    expect(subject.categories).not_to be_empty
  end

  describe "#[]" do
    context "with Symbol" do
      it "should select User-Agent strings by group name" do
        expect(subject[:ie]).not_to be_nil
      end

      it "should return nil if the group exists" do
        expect(subject[:foobarbaz]).to be_nil
      end
    end

    context "with String" do
      it "should select User-Agent strings by substring" do
        expect(subject['MSIE']).not_to be_nil
      end

      it "should return nil if no User-Agent matches the substring" do
        expect(subject['FooBarBaz']).to be_nil
      end
    end

    context "with Regexp" do
      it "should select User-Agent strings by Regexp" do
        expect(subject[/AppleWebKit/i]).not_to be_nil
      end

      it "should return nil if no User-Agent matches the Regexp" do
        expect(subject[/FooBarBaz/i]).to be_nil
      end
    end
  end

  describe "#fetch" do
    it "should fetch a User-Agent string" do
      expect(subject.fetch(:ie)).not_to be_nil
    end

    it "should raise an ArgumentError if no match was found" do
      expect {
        subject.fetch(:foobarbaz)
      }.to raise_error(ArgumentError)
    end

    it "should return the default value if no match was found" do
      expect(subject.fetch(:foobarbaz,'default')).to eq('default')
    end
  end
end
