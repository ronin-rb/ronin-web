# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'
require './tasks/spec.rb'
require './lib/ronin/web/version.rb'

Hoe.spec('ronin-web') do
  self.rubyforge_name = 'ronin'
  self.developer('Postmodern', 'postmodern.mod3@gmail.com')
  self.remote_rdoc_dir = 'docs/ronin-web'
  self.extra_deps = [
    ['nokogiri', '>=1.2.0'],
    ['mechanize', '>=0.9.0'],
    ['spidr', '>=0.1.9'],
    ['rack', '>=1.0.0'],
    ['ronin', '>=0.2.2']
  ]
end

# vim: syntax=Ruby
