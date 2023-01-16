require 'spec_helper'
require 'ronin/web/cli/commands/server'
require_relative 'man_page_example'

describe Ronin::Web::CLI::Commands::Server do
  include_examples "man_page"
end
