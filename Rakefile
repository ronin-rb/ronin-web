require 'rubygems'
require 'rake'
require './lib/ronin/web/version.rb'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'ronin-web'
    gem.version = Ronin::Web::VERSION
    gem.summary = %Q{A Ruby library for Ronin that provides support for web scraping and spidering functionality.}
    gem.description = %Q{Ronin Web is a Ruby library for Ronin that provides support for web scraping and spidering functionality.}
    gem.email = 'postmodern.mod3@gmail.com'
    gem.homepage = 'http://github.com/ronin-ruby/ronin-web'
    gem.authors = ['Postmodern']
    gem.add_dependency 'nokogiri', '>= 1.4.1'
    gem.add_dependency 'mechanize', '>= 1.0.0'
    gem.add_dependency 'spidr', '>= 0.2.0'
    gem.add_dependency 'sinatra', '>= 0.9.4'
    gem.add_dependency 'ronin', '>= 0.3.0'
    gem.add_development_dependency 'rspec', '>= 1.3.0'
    gem.add_development_dependency 'yard', '>= 0.5.3'
    gem.add_development_dependency 'test-unit', '= 1.2.3'
    gem.add_development_dependency 'rack-test', '>= 0.4.1'
    gem.has_rdoc = 'yard'
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs += ['lib', 'spec']
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.spec_opts = ['--options', '.specopts']
end

task :spec => :check_dependencies
task :default => :spec

begin
  require 'yard'

  YARD::Rake::YardocTask.new
rescue LoadError
  task :yard do
    abort "YARD is not available. In order to run yard, you must: gem install yard"
  end
end
