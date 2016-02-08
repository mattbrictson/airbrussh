require "sshkit"

module Airbrussh
  # This class quacks like an SSHKit::Formatter, but when any formatting
  # methods are called, it simply forwards them to one more more concrete
  # formatters. This allows us to split out the responsibilities of
  # ConsoleFormatter and LogFileFormatter into two separate classes, with
  # DelegatingFormatter forwarding the logging messages to both at once.
  #
  class DelegatingFormatter
    FORWARD_METHODS = %w(
      fatal error warn info debug log
      log_command_start log_command_data log_command_exit
    ).freeze
    DUP_AND_FORWARD_METHODS = %w(<< write).freeze

    attr_reader :formatters

    def initialize(formatters)
      @formatters = formatters
    end

    FORWARD_METHODS.each do |method|
      define_method(method) do |*args|
        formatters.map { |f| f.public_send(method, *args) }.last
      end
    end

    # For versions of SSHKit up to and including 1.7.1, the LogfileFormatter
    # and ConsoleFormatter (and all of SSHKit's built in formatters) clear
    # the stdout and stderr data in the command obj. Therefore, ensure only
    # one of the formatters (the last one) gets the original command. This is
    # also the formatter whose return value is passed to the caller.
    #
    DUP_AND_FORWARD_METHODS.each do |method|
      define_method(method) do |command_or_log_message|
        formatters[0...-1].each do |f|
          f.public_send(method, command_or_log_message.dup)
        end
        formatters.last.public_send(method, command_or_log_message)
      end
    end
  end
end
