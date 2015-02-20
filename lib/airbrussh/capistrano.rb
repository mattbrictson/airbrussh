require "airbrussh"
require "colorize"
require "sshkit/formatter/airbrussh"

# airbrush/capistrano uses a different default configuration
Airbrussh.configure do |config|
  config.log_file = "log/capistrano.log"
  config.monkey_patch_rake = true
  config.color = :auto
  config.truncate = :auto
end

# Sanity check!
unless defined?(Capistrano) && defined?(:namespace)
  $stderr.puts\
    "WARNING: airbrussh/capistrano must be loaded by Capistrano in order "\
    "to work.\n"\
    "Require this gem within your application's Capfile, as described here:\n"\
    "https://github.com/mattbrictson/airbrussh#installation"\
    .colorize(:red)
end

# Hook into Capistrano's init process to set the formatter
namespace :load do
  task :defaults do
    set :format, :airbrussh
  end
end

# Capistrano failure hook
namespace :deploy do
  task :failed do
    output = env.backend.config.output
    output.on_deploy_failure if output.respond_to?(:on_deploy_failure)
  end
end
