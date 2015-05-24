module Airbrussh
  class Configuration
    class << self
      extend Forwardable
      attr_writer :current_formatter
      delegate :current_rake_task= => :@current_formatter
    end

    attr_accessor :log_file, :color, :truncate, :banner, :command_output

    def initialize
      self.log_file = nil
      self.monkey_patch_rake = false
      self.color = :auto
      self.truncate = :auto
      self.banner = :auto
      self.command_output = false
    end

    def command_output_stdout?
      command_output_include?(:stdout)
    end

    def command_output_stderr?
      command_output_include?(:stderr)
    end

    def monkey_patch_rake=(should_patch)
      ::Rake::Task.class_eval do
        patched = instance_methods(false).include?(:_original_execute_airbrussh)
        if should_patch && !patched
          define_method(:_original_execute_airbrussh, instance_method(:execute))
          def execute(args=nil)
            Airbrussh::Configuration.current_rake_task = name
            _original_execute_airbrussh(args)
            Airbrussh::Configuration.current_rake_task = nil
          end
        elsif !should_patch && patched
          define_method(:execute, instance_method(:_original_execute_airbrussh))
          remove_method :_original_execute_airbrussh
        end
      end
    end

    private

    def command_output_include?(sym)
      command_output == true || Array(command_output).include?(sym)
    end
  end
end
