require 'spec_helper'
require 'ronin/web/cli/commands/new/server'
require_relative '../man_page_example'

describe Ronin::Web::CLI::Commands::New::Server do
  include_examples "man_page"
end
