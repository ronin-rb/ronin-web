require 'rspec'

RSpec.configure do |specs|
  specs.filter_run_excluding :network
end
