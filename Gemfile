source 'https://rubygems.org'

DATA_MAPPER = 'http://github.com/datamapper'
RONIN = 'http://github.com/ronin-ruby'

# DataMapper dependencies
gem 'dm-core',		'~> 1.0.0', :git => "#{DATA_MAPPER}/dm-core.git"
gem 'dm-migrations',	'~> 1.0.0', :git => 'http://github.com/postmodern/dm-migrations.git', :branch => 'runner'

gem 'data_paths',	'~> 0.2.1'
gem 'nokogiri',		'~> 1.4.1'
gem 'mechanize',	'~> 1.0.0'
gem 'spidr',		'~> 0.2.0'
gem 'sinatra',		'~> 1.0'
gem 'ronin-support',	'~> 0.1.0', :git => "#{RONIN}/ronin-support.git"
gem 'ronin',		'~> 0.4.0', :git => "#{RONIN}/ronin.git"

group(:development) do
  gem 'rake',		'~> 0.8.7'
  gem 'jeweler',	'~> 1.5.0.pre'
end

group(:doc) do
  case RUBY_PLATFORM
  when 'java'
    gem 'maruku',	'~> 0.6.0'
  else
    gem 'rdiscount',	'~> 1.6.3'
  end

  gem 'yard',		'~> 0.5.3'
end

group(:test) do
  gem 'rack-test',	'~> 0.5.4'
end

gem 'rspec',	'~> 2.0.0.beta.20', :group => [:development, :test]
