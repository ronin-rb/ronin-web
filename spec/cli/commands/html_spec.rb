require 'spec_helper'
require 'ronin/web/cli/commands/html'
require_relative 'man_page_example'

describe Ronin::Web::CLI::Commands::Html do
  include_examples "man_page"
end
