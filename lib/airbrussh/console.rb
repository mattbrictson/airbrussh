# encoding: UTF-8
require "io/console"

module Airbrussh
  # Helper class that wraps an IO object and provides methods for truncating
  # output, assuming the IO object represents a console window.
  #
  # If color is disabled for the IO object (based on Airbrussh::Configuration),
  # any ANSI color codes will also be stripped from the output.
  #
  class Console
    attr_reader :output, :config

    def initialize(output, config=Airbrussh.configuration)
      @output = output
      @config = config
    end

    # Writes to the IO after first truncating the output to fit the console
    # width. If color is disabled for the underlying IO, ANSI colors are also
    # removed from the output. A newline is always added.
    def print_line(obj="")
      string = obj.to_s

      string = truncate_to_console_width(string) if console_width
      string = strip_ascii_color(string) unless color_enabled?

      write(string + "\n")
      output.flush
    end

    # Writes directly through to the IO with no truncation or color logic.
    # No newline is added.
    def write(string)
      output.write(string || "")
    end
    alias_method :<<, :write

    def truncate_to_console_width(string)
      string = (string || "").rstrip
      ellipsis = utf8_supported?(string) ? "…" : "..."
      width = console_width

      if strip_ascii_color(string).length > width
        width -= ellipsis.length
        string.chop! while strip_ascii_color(string).length > width
        string << "#{ellipsis}\e[0m"
      else
        string
      end
    end

    def strip_ascii_color(string)
      (string || "").gsub(/\033\[[0-9;]*m/, "")
    end

    def console_width
      case (truncate = config.truncate)
      when :auto
        IO.console.winsize.last if @output.tty?
      when Fixnum
        truncate
      end
    end

    private

    def color_enabled?
      @color_enabled ||= config.colors(output).enabled?
    end

    def utf8_supported?(string)
      string.encode("UTF-8").valid_encoding?
    rescue Encoding::UndefinedConversionError
      false
    end
  end
end
