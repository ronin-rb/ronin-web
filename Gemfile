source 'https://rubygems.org'

DATA_MAPPER = 'http://github.com/datamapper'
DM_VERSION = '~> 1.0.2'
RONIN = 'http://github.com/ronin-ruby'

gemspec

gem 'rack',           '~> 1.2.1', :git => 'http://github.com/rack/rack.git'

# Ronin dependencies
gem 'ronin-support',	'~> 0.1.0', :git => "#{RONIN}/ronin-support.git"
gem 'ronin',		      '~> 1.0.0', :git => "#{RONIN}/ronin.git"

group :development do
  gem 'rake',		      '~> 0.8.7'

  gem 'ore-core',     '~> 0.1.0'
  gem 'ore-tasks',    '~> 0.2.0'

  gem 'rspec',        '~> 2.0.0'
  gem 'rack-test',    '~> 0.5.6'

  gem 'kramdown',     '~> 0.12.0'
end
