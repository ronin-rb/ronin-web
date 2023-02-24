source 'https://rubygems.org'

gemspec

if RUBY_VERSION >= '3.0'
  # XXX: dep in webrick for mechanize for Ruby 3.0
  gem 'webrick', platform: :ruby
end

platforms :jruby do
  gem 'jruby-openssl', '~> 0.7'
end

# gem 'nokogiri-ext', '~> 0.1', github: 'postmodern/nokogiri-ext',
#                               branch: 'main'
# gem 'rack',         '~> 1.2', github: 'rack/rack'
# gem 'sinatra',      '~> 1.2', github: 'sinatra/sinatra'

# gem 'command_kit',  '~> 0.4', github: 'postmodern/command_kit.rb',
#                               branch: '0.4.0'

# gem 'spidr', '~> 0.7', github: 'postmodern/spidr'

# Ronin dependencies
# gem 'ronin-support',         '~> 1.0', github: "ronin-rb/ronin-support",
#                                        branch: 'main'
# gem 'ronin-web-server',      '~> 0.1', github: "ronin-rb/ronin-web-server",
#                                        branch: 'main'
# gem 'ronin-web-spider',      '~> 0.1', github: "ronin-rb/ronin-web-spider",
#                                        branch: 'main'
# gem 'ronin-web-user_agents', '~> 0.1', github: "ronin-rb/ronin-web-user_agents",
#                                        branch: 'main'
# gem 'ronin-core',	       '~> 0.1', github: "ronin-rb/ronin-core",
#                                        branch: 'main'

group :development do
  gem 'rake'
  gem 'rubygems-tasks',  '~> 0.1'

  gem 'rspec',           '~> 3.0'
  gem 'simplecov',       '~> 0.20'
  gem 'rack-test',       '~> 0.6'

  gem 'kramdown',        '~> 2.0'
  gem 'redcarpet',       platform: :mri
  gem 'yard',            '~> 0.9'
  gem 'yard-spellcheck', require: false

  gem 'kramdown-man',    '~> 0.1'

  gem 'dead_end',        require: false
  gem 'sord',            require: false, platform: :mri
  gem 'stackprof',       require: false, platform: :mri
end
