source 'https://rubygems.org'

DM_URI = 'http://github.com/datamapper'
DM_VERSION = '~> 1.1.0'
RONIN_URI = 'http://github.com/ronin-ruby'

gem 'rack', '~> 1.2.0', :git => 'http://github.com/rack/rack.git'

gemspec

# Ronin dependencies
# gem 'ronin-support',	'~> 0.1.0', :git => "#{RONIN_URI}/ronin-support.git"
# gem 'ronin',		      '~> 1.0.0', :git => "#{RONIN_URI}/ronin.git"

group :test do
  gem 'rack-test',    '~> 0.5.7'
end

group :development do
  gem 'rake',		      '~> 0.8.7'

  gem 'ore-tasks',    '~> 0.4'
  gem 'rspec',        '~> 2.4'

  gem 'kramdown',     '~> 0.12'
end
