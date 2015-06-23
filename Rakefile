require "bundler/gem_tasks"

require "rake/testtask"
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

require "rubocop/rake_task"
RuboCop::RakeTask.new

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.1.0")
  require "chandler/tasks"
  task "release:rubygem_push" => "chandler:push"
end

task :default => [:test, :rubocop]
