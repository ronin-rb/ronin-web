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
    ['nokogiri', '>=1.2.0'],
    ['mechanize', '>=0.9.0'],
    ['spidr', '>=0.1.3'],
    ['rack', '>=1.0.0'],
    ['ronin', '>=0.2.2']
  ]
end

# vim: syntax=Ruby
