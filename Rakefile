# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'

Hoe.plugin :yard

Hoe.spec('ronin-web') do
  self.rubyforge_name = 'ronin'
  self.developer('Postmodern', 'postmodern.mod3@gmail.com')

  self.rspec_options += ['--colour', '--format', 'specdoc']

  self.yard_options += ['--markup', 'markdown', '--protected']
  self.remote_yard_dir = 'docs/ronin-web'

  self.extra_deps = [
    ['ronin', '>=0.4.0'],
    ['nokogiri', '>=1.4.1'],
    ['mechanize', '>=1.0.0'],
    ['spidr', '>=0.2.0'],
    ['sinatra', '>=0.9.4']
  ]

  self.extra_dev_deps = [
    ['rspec', '>=1.3.0'],
    ['yard', '>=0.5.3'],
    ['test-unit', '=1.2.3'],
    ['rack-test', '>=0.4.1']
  ]
end

# vim: syntax=Ruby
