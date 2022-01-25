source 'https://rubygems.org'

DM_URI     = 'https://github.com/datamapper'
DM_VERSION = '~> 1.2'
RONIN_URI  = 'https://github.com/ronin-rb'

gemspec

platforms :jruby do
  gem 'jruby-openssl', '~> 0.7'
end

gem 'nokogiri-ext', '~> 0.1', github: 'postmodern/nokogiri-ext',
                              branch: 'main'
# gem 'rack',         '~> 1.2', git: 'https://github.com/rack/rack.git'
# gem 'sinatra',      '~> 1.2', git: 'https://github.com/sinatra/sinatra.git'

# Ronin dependencies
# gem 'ronin-support',	'~> 0.4', git: "#{RONIN_URI}/ronin-support.git"
gem 'ronin-web-server',	'~> 0.1', git: "#{RONIN_URI}/ronin-web-server.git",
                                  branch: 'main'

gem 'ronin-web-spider',	'~> 0.1', git: "#{RONIN_URI}/ronin-web-spider.git",
                                  branch: 'main'

gem 'ronin-web-user_agents',	'~> 0.1', git: "#{RONIN_URI}/ronin-web-user_agents.git",
                                        branch: 'main'

# gem 'ronin',		      '~> 1.4', git: "#{RONIN_URI}/ronin.git"

# XXX: dep in webrick for mechanize for Ruby 3.0
platform :ruby do
  gem 'webrick' if RUBY_VERSION >= '3.0'
end

group :test do
  gem 'rack-test',    '~> 0.6'
end

group :development do
  gem 'rake'

  gem 'rubygems-tasks', '~> 0.1'
  gem 'rspec',          '~> 3.0'

  gem 'kramdown',       '~> 2.0'
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
  gem "dm-#{adapter}-adapter", DM_VERSION #, git: "#{DM_URI}/dm-#{adapter}-adapter.git"
end
