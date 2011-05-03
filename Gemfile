source 'https://rubygems.org'

DM_URI = 'http://github.com/datamapper'
DM_VERSION = '~> 1.1.0'
RONIN_URI = 'http://github.com/ronin-ruby'

gemspec

# gem 'rack',         '~> 1.2', :git => 'http://github.com/rack/rack.git'
# gem 'sinatra',      '~> 1.2', :git => 'http://github.com/sinatra/sinatra.git'

gem 'data_paths', '~> 0.3.0', :git => 'http://github.com/postmodern/data_paths.git'

# Ronin dependencies
gem 'ronin-support',	'~> 0.2', :git => "#{RONIN_URI}/ronin-support.git"
gem 'ronin',		      '~> 1.1', :git => "#{RONIN_URI}/ronin.git"

group :test do
  gem 'rack',         '~> 1.2', :git => 'http://github.com/rack/rack.git'
  gem 'rack-test',    '~> 0.6.0'
end

group :development do
  gem 'rake',		      '~> 0.8.7'

  gem 'ore-tasks',    '~> 0.4'
  gem 'rspec',        '~> 2.4'

  gem 'kramdown',     '~> 0.12'
end

#
# To enable additional DataMapper adapters for development work or for
# testing purposes, simple set the ADAPTER or ADAPTERS environment
# variable:
#
#     export ADAPTER="postgres"
#     bundle install
#
#     ./bin/ronin --database postgres://ronin@localhost/ronin
#
require 'set'

DM_ADAPTERS = Set['postgres', 'mysql', 'oracle', 'sqlserver']

adapters = (ENV['ADAPTER'] || ENV['ADAPTERS']).to_s
adapters = Set.new(adapters.to_s.tr(',',' ').split)

(DM_ADAPTERS & adapters).each do |adapter|
  gem "dm-#{adapter}-adapter", DM_VERSION #, :git => "#{DM_URI}/dm-#{adapter}-adapter.git"
end
