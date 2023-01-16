require 'spec_helper'
require 'ronin/web/cli/commands/spider'
require_relative 'man_page_example'

describe Ronin::Web::CLI::Commands::Spider do
  include_examples "man_page"
end
