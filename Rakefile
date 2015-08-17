require "bundler/gem_tasks"
require 'bundler/setup'
Bundler::GemHelper.install_tasks

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "spec" << "lib"
  t.pattern = "spec/**/*_spec.rb"
end

task(default: :test)

def load_gem
  $:.push File.expand_path("../lib", __FILE__)
  $:.push File.expand_path("../spec", __FILE__)
  require 'relay'
end


task :console do
  require 'irb'
  require 'irb/completion'
  load_gem_and_dummy
  ARGV.clear
  IRB.start
end
