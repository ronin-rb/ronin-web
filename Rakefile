# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './tasks/spec.rb'
require './lib/ronin/web/version.rb'

Hoe.new('ronin-web', Ronin::Web::VERSION) do |p|
  p.rubyforge_name = 'ronin'
  p.developer('Postmodern', 'postmodern.mod3@gmail.com')
  p.remote_rdoc_dir = 'docs/ronin-web'
  p.extra_deps = [
    ['ronin', '>=0.1.4'],
    'hpricot',
    'mechanize',
    ['spidr', '>=0.1.3'],
    ['rack', '>=0.9.1']
  ]
end

# vim: syntax=Ruby
