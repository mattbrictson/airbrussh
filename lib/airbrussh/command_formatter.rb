# encoding: UTF-8
require "airbrussh/colors"
require "forwardable"
# rubocop:disable Style/AsciiComments

module Airbrussh
  # Decorates an SSHKit Command to add string output helpers and the
  # command's position within currently executing rake task:
  #
  # * position - zero-based position of this command in the list of
  #              all commands that have been run in the current rake task
  #  class CommandFormatter < SimpleDelegator
  class CommandFormatter < SimpleDelegator
    extend Forwardable
    def_delegators :@colors, *Airbrussh::Colors.names

    def initialize(command, position, colors=Airbrussh::Colors.new)
      super(command)
      @position = position
      @colors = colors
    end

    # Prefixes the line with the command number and removes the newline.
    #
    # format_output("hello\n") # => "01 hello"
    #
    def format_output(line)
      "#{number} #{line.chomp}"
    end

    # Returns the abbreviated command (in yellow) with the number prefix.
    #
    # start_message # => "01 echo hello"
    #
    def start_message
      "#{number} #{yellow(abbreviated)}"
    end

    # Returns a green (success) or red (failure) message depending on the
    # exit status.
    #
    # exit_message # => "✔ 01 user@host 0.084s"
    # exit_message # => "✘ 01 user@host 0.084s"
    #
    # If `log_file` is specified, it is appended to the message
    # in the failure case.
    #
    # exit_message("out.log")
    # # => "✘ 01 user@host (see out.log for details) 0.084s"
    #
    def exit_message(log_file=nil)
      if failure?
        message = red(failure_message(log_file))
      else
        message = green(success_message)
      end
      message << " #{gray(runtime)}"
    end

    private

    def user_at_host
      user_str = host.user || (host.ssh_options || {})[:user]
      host_str = host.hostname
      [user_str, host_str].compact.join("@")
    end

    def runtime
      format("%5.3fs", super)
    end

    def abbreviated
      to_s.sub(%r{^/usr/bin/env }, "")
    end

    def number
      format("%02d", @position + 1)
    end

    def success_message
      "✔ #{number} #{user_at_host}"
    end

    def failure_message(log_file)
      message = "✘ #{number} #{user_at_host}"
      message << " (see #{log_file} for details)" if log_file
      message
    end
  end
end
