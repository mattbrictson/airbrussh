require "airbrussh"
require "airbrussh/colors"
require "airbrussh/console"
require "forwardable"
require "shellwords"

module Airbrussh
  module Capistrano
    # Encapsulates the rake behavior that integrates Airbrussh into Capistrano.
    # This class allows us to easily test the behavior using a mock to stand in
    # for the Capistrano DSL.
    #
    # See airbrussh/capistrano.rb to see how this class is used.
    #
    class Tasks
      extend Forwardable
      def_delegators :dsl, :set
      def_delegators :config, :log_file

      include Airbrussh::Colors

      def initialize(dsl, stderr=$stderr, config=Airbrussh.configuration)
        @dsl = dsl
        @stderr = stderr
        @config = config

        configure
        warn_if_missing_dsl
      end

      # Behavior for the rake load:defaults task.
      def load_defaults
        set :format, :airbrussh
      end

      # Behavior for the rake deploy:failed task.
      def deploy_failed
        return if log_file.nil?

        error_line
        error_line(red("** DEPLOY FAILED"))
        error_line(yellow("** Refer to #{log_file} for details. "\
                          "Here are the last 20 lines:"))
        error_line
        error_line(`tail -n 20 #{log_file.shellescape} 2>&1`)
      end

      private

      attr_reader :dsl, :stderr, :config

      # Change airbrussh's default configuration to be more appropriate for
      # capistrano.
      def configure
        config.log_file = "log/capistrano.log"
        config.monkey_patch_rake = true
      end

      # Verify that capistrano and rake DSLs are present
      def warn_if_missing_dsl
        return if %w(set namespace task).all? { |m| dsl.respond_to?(m) }

        error_line(
          red("WARNING: airbrussh/capistrano must be loaded by Capistrano in "\
              "order to work.\nRequire this gem within your application's "\
              "Capfile, as described here:\n"\
              "https://github.com/mattbrictson/airbrussh#installation"))
      end

      def err_console
        @err_console ||= Airbrussh::Console.new(stderr)
      end

      def error_line(line="\n")
        line.each_line(&err_console.method(:print_line))
      end
    end
  end
end
