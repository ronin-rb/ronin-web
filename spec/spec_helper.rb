require 'rspec'
require 'simplecov'
require 'webmock/rspec'

SimpleCov.start

RSpec.configure do |specs|
  specs.filter_run_excluding :network

  specs.before(:suite) do
    WebMock.disable_net_connect!(allow_localhost: true)
  end
end
