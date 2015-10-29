require "airbrussh/colors"
require "airbrussh/console_formatter"
require "airbrussh/log_file_formatter"

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

    # Returns a configured Colors object appropriate for the given io.
    # This is based on the color setting (true, false, or :auto), and whether
    # the io is a tty.
    def colors(io)
      Airbrussh::Colors.new(color?(io))
    end

    def banner_message(io)
      return nil unless banner
      return banner unless banner == :auto
      m = "Using airbrussh format."
      if log_file
        m << "\n"
        m << "Verbose output is being written to #{colors(io).blue(log_file)}."
      end
      m
    end

    # This returns an array of formatters appropriate for the configuration.
    # Depending on whether a log file is configured, this could be just the
    # Airbrussh:ConsoleFormatter, or that plus the LogFileFormatter.
    def formatters(io)
      fmts = [Airbrussh::ConsoleFormatter.new(io, self)]
      fmts.unshift(Airbrussh::LogFileFormatter.new(log_file)) if log_file
      fmts
    end

    def show_command_output?(sym)
      command_output == true || Array(command_output).include?(sym)
    end

    private

    def color?(io)
      case color
      when true
        true
      when :auto
        ENV["SSHKIT_COLOR"] || (io.respond_to?("tty?") && io.tty?)
      else
        false
      end
    end
  end
end
