require 'spec_helper'
require 'ronin/web'

describe Ronin::Web do
  let(:url) { 'https://example.com/' }

  it "should have a VERSION constant" do
    expect(subject.const_defined?('VERSION')).to eq(true)
  end

  it "must include Ronin::Support::Web" do
    expect(subject).to include(Ronin::Support::Web)
  end
end
