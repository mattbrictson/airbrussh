require "rake"

module Airbrussh
  module Rake
    # Maintains information about what Rake task is currently being invoked,
    # in order to be able to decorate SSHKit commands with additional
    # context-sensitive information. Works via a monkey patch to Rake::Task,
    # which can be disabled via by setting
    # Airbrussh.configuration.monkey_patch_rake = false.
    #
    # Note that this class is not thread-safe. Normally this is not a problem,
    # but some Capistrano users are known to use `invoke` to switch the Rake
    # task in the middle of an SSHKit thread, which causes Context to get very
    # confused. It such scenarios Context is not reliable and may return `nil`
    # for the `position` of a command.
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

      # Update the context when a new command starts by:
      # * Clearing the command history if the rake task has changed
      # * Recording the command in the history
      #
      # Returns whether or not this command was the first execution
      # of this command in the current rake task
      def register_new_command(command)
        reset_history_if_task_changed

        first_execution = !history.include?(command.to_s)
        history << command.to_s
        history.uniq!
        first_execution
      end

      # The zero-based position of the specified command in the current rake
      # task. May be `nil` in certain multi-threaded scenarios, so be careful!
      def position(command)
        history.index(command.to_s)
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
