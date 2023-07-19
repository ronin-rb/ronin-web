require 'spec_helper'
require 'ronin/web/cli/ruby_shell'

describe Ronin::Web::CLI::RubyShell do
  describe "#initialize" do
    it "must default #name to 'ronin-web'" do
      expect(subject.name).to eq('ronin-web')
    end

    it "must default context: to Ronin::Web" do
      expect(subject.context).to be_a(Object)
      expect(subject.context).to be_kind_of(Ronin::Web)
    end
  end
end
