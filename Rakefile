require "bundler/gem_tasks"
require "chandler/tasks"
task "release:rubygem_push" => "chandler:push"

require "rake/testtask"
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
end

require "rubocop/rake_task"
RuboCop::RakeTask.new

task :default => [:test, :rubocop]
