require 'rspec'
require 'ronin/web/version'

RSpec.configure do |specs|
  specs.filter_run_excluding :network
end
