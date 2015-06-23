require "rake"
require "airbrussh/rake/command"

module Airbrussh
  module Rake
    # Maintains information about what Rake task is currently being invoked,
    # in order to be able to decorate SSHKit commands with additional
    # context-sensitive information. Works via a monkey patch to Rake::Task,
    # which can be disabled via by setting
    # Airbrussh.configuration.monkey_patch_rake = false.
    #
    class Context
      def initialize(config=Airbrussh.configuration)
        @history = []
        @enabled = config.monkey_patch_rake
        self.class.install_monkey_patch if enabled?
      end

      # Returns the name of the currently-executing rake task, if it can be
      # determined. If monkey patching is disabled, this will be nil.
      def current_task_name
        return nil unless enabled?
        self.class.current_task_name
      end

      # Decorate an SSHKit Command with Rake::Command to provide additional
      # context-sensitive information.
      def decorate_command(command)
        reset_history_if_task_changed

        first_execution = !history.include?(command.to_s)
        history << command.to_s
        history.uniq!

        Airbrussh::Rake::Command.new(
          command,
          first_execution,
          history.index(command.to_s)
        )
      end

      class << self
        attr_accessor :current_task_name

        def install_monkey_patch
          return if ::Rake::Task.instance_methods.include?(:_airbrussh_execute)

          ::Rake::Task.class_exec do
            alias_method :_airbrussh_execute, :execute
            def execute(args=nil) # rubocop:disable Lint/NestedMethodDefinition
              ::Airbrussh::Rake::Context.current_task_name = name.to_s
              _airbrussh_execute(args)
            end
          end
        end
      end

      private

      attr_reader :history
      attr_accessor :last_task_name

      def reset_history_if_task_changed
        history.clear if last_task_name != current_task_name
        self.last_task_name = current_task_name
      end

      def enabled?
        @enabled
      end
    end
  end
end
