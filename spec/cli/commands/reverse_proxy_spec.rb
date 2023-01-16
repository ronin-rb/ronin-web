require 'spec_helper'
require 'ronin/web/cli/commands/reverse_proxy'
require_relative 'man_page_example'

describe Ronin::Web::CLI::Commands::ReverseProxy do
  include_examples "man_page"
end
