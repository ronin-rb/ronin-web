source 'https://rubygems.org'

RONIN_URI  = 'https://github.com/ronin-rb'

gemspec

# XXX: dep in webrick for mechanize for Ruby 3.0
platform :ruby do
  gem 'webrick' if RUBY_VERSION >= '3.0'
end

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

gem 'ronin-core',	'~> 0.1', git: "#{RONIN_URI}/ronin-core.git",
                            branch: 'main'

group :development do
  gem 'rake'
  gem 'rubygems-tasks', '~> 0.1'

  gem 'rspec',          '~> 3.0'
  gem 'rack-test',      '~> 0.6'

  gem 'kramdown',       '~> 2.0'
  gem 'yard',           '~> 0.9'

  gem 'kramdown-man',   '~> 0.1'
end
