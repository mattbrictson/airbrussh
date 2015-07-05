require "airbrussh/formatter"

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

    # This returns an array of formatters appropriate for the configuration.
    # Currently this always returns a single Airbrussh::Formatter, but in the
    # future this may include a second formatter which has the sole purpose
    # of writing to the log_file, if a log_file is specified. This change will
    # happen once the file-related IO responsibilities are factored out of
    # Airbrussh::Formatter into a new class.
    #
    def formatters(io)
      [Airbrussh::Formatter.new(io, self)]
    end

    def show_command_output?(sym)
      command_output == true || Array(command_output).include?(sym)
    end
  end
end
