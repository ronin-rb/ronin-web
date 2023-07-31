require 'spec_helper'
require 'ronin/web/cli/commands/browser'
require_relative 'man_page_example'

describe Ronin::Web::CLI::Commands::Browser do
  include_examples "man_page"
end
