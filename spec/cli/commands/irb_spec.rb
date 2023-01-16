require 'spec_helper'
require 'ronin/web/cli/commands/irb'
require_relative 'man_page_example'

describe Ronin::Web::CLI::Commands::Irb do
  include_examples "man_page"
end
