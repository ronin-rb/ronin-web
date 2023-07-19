require 'spec_helper'
require 'ronin/web/cli/commands/wordlist'
require_relative 'man_page_example'

describe Ronin::Web::CLI::Commands::Wordlist do
  include_examples "man_page"
end
