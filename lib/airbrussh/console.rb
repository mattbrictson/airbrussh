# encoding: UTF-8
require "io/console"

module Airbrussh
  # Helper class that wraps an IO object and provides methods for truncating
  # output, assuming the IO object represents a console window.
  class Console
    attr_reader :output, :config

    def initialize(output, config=Airbrussh.configuration)
      @output = output
      @config = config
    end

    # Writes to the IO after first truncating the output to fit the console
    # width. A newline is always added.
    def print_line(obj="")
      string = obj.to_s
      string = truncate_to_console_width(string) if console_width
      write(string + "\n")
      output.flush
    end

    # Writes directly through to the IO with no truncation logic.
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
        string << ellipsis + ("\e[0m" if contains_ascii_color?(string)).to_s
      else
        string
      end
    end

    def strip_ascii_color(string)
      (string || "").gsub(/\033\[[0-9;]*m/, "")
    end

    def contains_ascii_color?(string)
      string =~ /\033\[[0-9;]*m/
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

    def utf8_supported?(string)
      string.encode("UTF-8").valid_encoding?
    rescue Encoding::UndefinedConversionError
      false
    end
  end
end
