require "bundler/gem_tasks"

require "rake/testtask"
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

require "rubocop/rake_task"
RuboCop::RakeTask.new

# rubocop:disable Lint/HandleExceptions
begin
  require "chandler/tasks"
rescue LoadError
end
task "release:rubygem_push" => "chandler:push" if defined?(Chandler)

task :default => [:test, :rubocop]
