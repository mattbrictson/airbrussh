require "io/console"

module Airbrussh
  # Helper class that wraps an IO object and provides methods for truncating
  # output, assuming the IO object represents a console window.
  #
  # This is useful for writing log messages that will typically show up on
  # an ANSI color-capable console. When a console is not present (e.g. when
  # running on a CI server) the output will gracefully degrade.
  class Console
    def initialize(output)
      @output = output
    end

    # Writes to the IO after first truncating the output to fit the console
    # width. If the underlying IO is not a TTY, ANSI colors are removed from
    # the output. A newline is always added. Color output can be forced by
    # setting the SSHKIT_COLOR environment variable.
    def print_line(obj="")
      string = obj.to_s

      if console_width
        string = truncate_to_console_width(string)
      end
      unless ENV["SSHKIT_COLOR"] || @output.tty?
        string = strip_ascii_color(string)
      end

      write(string + "\n")
      @output.flush
    end

    # Writes directly through to the IO with no truncation or color logic.
    # No newline is added.
    def write(string)
      @output.write(string || "")
    end
    alias_method :<<, :write

    def truncate_to_console_width(string)
      string = (string || "").rstrip
      width = console_width

      if strip_ascii_color(string).length > width
        while strip_ascii_color(string).length >= width
          string.chop!
        end
        string << "…\e[0m"
      else
        string
      end
    end

    def strip_ascii_color(string)
      (string || "").gsub(/\033\[[0-9;]*m/, "")
    end

    def console_width
      IO.console.winsize.last if @output.tty?
    end
  end
end
