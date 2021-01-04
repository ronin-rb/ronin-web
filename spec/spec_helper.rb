require 'rspec'
require 'ronin/spec/database'
require 'ronin/spec/ui/output'

require 'ronin/web/version'

include Ronin

RSpec.configure do |specs|
  specs.filter_run_excluding :network
end
