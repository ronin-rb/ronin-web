require 'spec_helper'
require 'ronin/web/cli/commands/screenshot'
require_relative 'man_page_example'

describe Ronin::Web::CLI::Commands::Screenshot do
  include_examples "man_page"
end
