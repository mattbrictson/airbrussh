require "airbrussh"
require "airbrussh/colors"
require "airbrussh/console"
require "sshkit/formatter/airbrussh"
require "shellwords"

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
    log_file = Airbrussh.configuration.log_file
    next if log_file.nil?

    err = Airbrussh::Console.new($stderr)
    err.print_line
    err.print_line(Airbrussh::Colors.red("** DEPLOY FAILED"))
    err.print_line(
      Airbrussh::Colors.yellow(
        "** Refer to #{log_file} for details. Here are the last 20 lines:"
      ))
    err.print_line
    err.write(`tail -n 20 #{log_file.shellescape} 2>&1`)
  end
end
