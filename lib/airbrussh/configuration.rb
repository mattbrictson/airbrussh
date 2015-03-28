module Airbrussh
  class Configuration
    attr_accessor :log_file, :monkey_patch_rake, :color, :truncate, :banner,
                  :command_output

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

    private

    def command_output_include?(sym)
      command_output == true || Array(command_output).include?(sym)
    end
  end
end
