# frozen_string_literal: true

begin
  require 'bundler'
rescue LoadError => e
  warn e.message
  warn "Run `gem install bundler` to install Bundler."
  exit e.status_code
end

begin
  Bundler.setup(:development)
rescue Bundler::BundlerError => e
  warn e.message
  warn "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

require 'rubygems/tasks'
Gem::Tasks.new(sign: {checksum: true, pgp: true})

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new
task :test    => :spec
task :default => :spec

namespace :spec do
  RSpec::Core::RakeTask.new(:network) do |t|
    t.rspec_opts = '--tag network'
  end
end

require 'yard'
YARD::Rake::YardocTask.new

require 'kramdown/man/task'
Kramdown::Man::Task.new

require 'command_kit/completion/task'
CommandKit::Completion::Task.new(
  class_file:  'ronin/web/cli',
  class_name:  'Ronin::Web::CLI',
  output_file: 'data/completions/ronin-web'
)

task :setup => %w[man command_kit:completion]
