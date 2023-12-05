require 'spec_helper'
require 'ronin/web/cli/commands/vulns'
require_relative 'man_page_example'

describe Ronin::Web::CLI::Commands::Vulns do
  include_examples "man_page"
end
