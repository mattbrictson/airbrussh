# encoding: UTF-8

require "io/console"

module Airbrussh
  # Helper class that wraps an IO object and provides methods for truncating
  # output, assuming the IO object represents a console window.
  #
  # This is useful for writing log messages that will typically show up on
  # an ANSI color-capable console. When a console is not present (e.g. when
  # running on a CI server) the output will gracefully degrade.
  class Console
    attr_reader :output, :config

    def initialize(output, config=Airbrussh.configuration)
      @output = output
      @config = config
    end

    # Writes to the IO after first truncating the output to fit the console
    # width. If the underlying IO is not a TTY, ANSI colors are removed from
    # the output. A newline is always added. Color output can be forced by
    # setting the SSHKIT_COLOR environment variable.
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
    alias << write

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
      width = case (truncate = config.truncate)
              when :auto
                IO.console.winsize.last if @output.tty?
              when Integer
                truncate
              end

      width if width.to_i > 0
    end

    private

    def color_enabled?
      case config.color
      when true
        true
      when :auto
        ENV["SSHKIT_COLOR"] || @output.tty?
      else
        false
      end
    end

    def utf8_supported?(string)
      string.encode("UTF-8").valid_encoding?
    rescue Encoding::UndefinedConversionError
      false
    end
  end
end
