# encoding: UTF-8
require "airbrussh/colors"
require "delegate"
# rubocop:disable Style/AsciiComments

module Airbrussh
  # Decorates an SSHKit Command to add string output helpers and the
  # command's position within currently executing rake task:
  #
  # * position - zero-based position of this command in the list of
  #              all commands that have been run in the current rake task; in
  #              some cases this could be nil
  class CommandFormatter < SimpleDelegator
    include Airbrussh::Colors

    def initialize(command, position)
      super(command)
      @position = position
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
    def exit_message
      message = if failure?
                  red(failure_message)
                else
                  green(success_message)
                end
      message << " #{runtime}"
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
      format("%02d", @position.to_i + 1)
    end

    def success_message
      "✔ #{number} #{user_at_host}"
    end

    def failure_message
      "✘ #{number} #{user_at_host}"
    end
  end
end
