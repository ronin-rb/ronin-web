require 'spec_helper'
require 'ronin/web/cli/commands/new'
require_relative 'man_page_example'

describe Ronin::Web::CLI::Commands::New do
  include_examples "man_page"
end
