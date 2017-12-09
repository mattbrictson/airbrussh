require "bundler/gem_tasks"

require "rake/testtask"
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

begin
  require "rubocop/rake_task"
  RuboCop::RakeTask.new
  task :default => [:test, :rubocop]
rescue LoadError
  task :default => :test
end

# rubocop:disable Lint/HandleExceptions
begin
  require "chandler/tasks"
rescue LoadError
end
task "release:rubygem_push" => "chandler:push" if defined?(Chandler)
