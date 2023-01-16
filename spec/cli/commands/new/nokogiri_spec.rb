require 'spec_helper'
require 'ronin/web/cli/commands/new/nokogiri'
require_relative '../man_page_example'

describe Ronin::Web::CLI::Commands::New::Nokogiri do
  include_examples "man_page"
end
