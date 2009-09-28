# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'
require './tasks/spec.rb'
require './tasks/yard.rb'

Hoe.spec('ronin-web') do
  self.rubyforge_name = 'ronin'
  self.developer('Postmodern', 'postmodern.mod3@gmail.com')
  self.remote_rdoc_dir = 'docs/ronin-web'
  self.extra_deps = [
    ['mechanize', '>=0.9.3'],
    ['spidr', '>=0.1.10'],
    ['sinatra', '>=0.9.4'],
    ['ronin', '>=0.3.0']
  ]

  self.extra_dev_deps = [
    ['rspec', '>=1.2.8'],
    ['test-unit', '=1.2.3'],
    ['rack-test', '>=0.4.1']
  ]

  self.spec_extras = {:has_rdoc => 'yard'}
end

# vim: syntax=Ruby
