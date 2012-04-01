source 'https://rubygems.org'

DM_URI     = 'http://github.com/datamapper'
DM_VERSION = '~> 1.2'
RONIN_URI  = 'http://github.com/ronin-ruby'

gemspec

platforms :jruby do
  gem 'jruby-openssl', '~> 0.7'
end

# gem 'rack',         '~> 1.2', :git => 'http://github.com/rack/rack.git'
# gem 'sinatra',      '~> 1.2', :git => 'http://github.com/sinatra/sinatra.git'

# Ronin dependencies
# gem 'ronin-support',	'~> 0.4', :git => "#{RONIN_URI}/ronin-support.git"
# gem 'ronin',		      '~> 1.4', :git => "#{RONIN_URI}/ronin.git"

group :test do
  gem 'rack-test',    '~> 0.6'
end

group :development do
  gem 'rake',		      '~> 0.8'

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
