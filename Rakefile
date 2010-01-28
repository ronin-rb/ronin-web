# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'

Hoe.plugin :yard

Hoe.spec('ronin-web') do
  self.rubyforge_name = 'ronin'
  self.developer('Postmodern', 'postmodern.mod3@gmail.com')

  self.rspec_options += ['--colour', '--format', 'specdoc']

  self.yard_options += ['--protected']
  self.remote_yard_dir = 'docs/ronin-web'

  self.extra_deps = [
    ['nokogiri', '>=1.4.1'],
    ['mechanize', '>=0.9.3'],
    ['spidr', '>=0.2.0'],
    ['sinatra', '>=0.9.4'],
    ['ronin', '>=0.3.1']
  ]

  self.extra_dev_deps = [
    ['rspec', '>=1.2.8'],
    ['yard', '>=0.5.2'],
    ['test-unit', '=1.2.3'],
    ['rack-test', '>=0.4.1']
  ]
end

# vim: syntax=Ruby
