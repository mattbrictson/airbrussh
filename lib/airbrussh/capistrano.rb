require "airbrussh/capistrano/tasks"

tasks = Airbrussh::Capistrano::Tasks.new(self)

# Hook into Capistrano's init process to set the formatter
namespace :load do
  task :defaults do
    tasks.load_defaults
  end
end

# Capistrano failure hook
namespace :deploy do
  task :failed do
    tasks.deploy_failed
  end
end
