require "bundler/gem_tasks"
require "rake/testtask"
require "rubocop/rake_task"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
end

RuboCop::RakeTask.new

task :default => [:test, :rubocop]
