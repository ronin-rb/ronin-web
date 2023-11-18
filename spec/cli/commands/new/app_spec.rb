require 'spec_helper'
require 'ronin/web/cli/commands/new/app'
require_relative '../man_page_example'

describe Ronin::Web::CLI::Commands::New::App do
  include_examples "man_page"
end
