require 'spec_helper'
require 'ronin/web/cli/commands/diff'
require_relative 'man_page_example'

describe Ronin::Web::CLI::Commands::Diff do
  include_examples "man_page"
end
