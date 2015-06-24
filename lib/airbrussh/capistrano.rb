require "airbrussh"
require "airbrussh/colors"
require "sshkit/formatter/airbrussh"

# airbrush/capistrano uses a different default configuration
Airbrussh.configure do |config|
  config.log_file = "log/capistrano.log"
  config.monkey_patch_rake = true
end

# Sanity check!
unless defined?(Capistrano) && defined?(:namespace)
  $stderr.puts(
    Airbrussh::Colors.red(
      "WARNING: airbrussh/capistrano must be loaded by Capistrano in order "\
      "to work.\nRequire this gem within your application's Capfile, as "\
      "described here:\nhttps://github.com/mattbrictson/airbrussh#installation"
    ))
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
