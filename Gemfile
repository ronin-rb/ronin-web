# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

platforms :jruby do
  gem 'jruby-openssl', '~> 0.7'
end

# gem 'nokogiri-ext', '~> 0.1', github: 'postmodern/nokogiri-ext',
#                               branch: 'main'
# gem 'rack',         '~> 1.2', github: 'rack/rack'
# gem 'sinatra',      '~> 1.2', github: 'sinatra/sinatra'

# gem 'command_kit',  '~> 0.4', github: 'postmodern/command_kit.rb',
#                               branch: '0.4.0'

# gem 'spidr',    '~> 0.7', github: 'postmodern/spidr'
# gem 'wordlist', '~> 1.0', github: 'postmodern/wordlist.rb'

# Ronin dependencies
gem 'ronin-support',     '~> 1.1', github: "ronin-rb/ronin-support",
                                   branch: '1.1.0'
gem 'ronin-support-web', '~> 0.1', github: "ronin-rb/ronin-support-web",
                                   branch: 'main'
gem 'ronin-core',        '~> 0.2', github: "ronin-rb/ronin-core",
                                   branch: '0.2.0'

gem 'ferrum',                      github: 'rubycdp/ferrum'
gem 'ronin-web-browser', '~> 0.1', github: 'ronin-rb/ronin-web-browser'
# gem 'ronin-web-server',      '~> 0.1', github: "ronin-rb/ronin-web-server",
#                                        branch: 'main'
# gem 'ronin-web-spider',      '~> 0.1', github: 'ronin-rb/ronin-web-spider',
#                                        branch: 'main'
# gem 'ronin-web-user_agents', '~> 0.1', github: 'ronin-rb/ronin-web-user_agents',
#                                        branch: 'main'
gem 'ronin-web-session_cookie', '~> 0.1', github: 'ronin-rb/ronin-web-session_cookie',
                                          branch: 'main'

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

  gem 'kramdown-man',    '~> 1.0'

  gem 'dead_end',        require: false
  gem 'sord',            require: false, platform: :mri
  gem 'stackprof',       require: false, platform: :mri
  gem 'rubocop',         require: false, platform: :mri
  gem 'rubocop-ronin',   require: false, platform: :mri

  gem 'command_kit-completion', '~> 0.1', require: false
end
