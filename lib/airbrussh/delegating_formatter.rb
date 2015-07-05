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
    )
    DUP_AND_FORWARD_METHODS = %w(<< write)

    attr_reader :formatters

    def initialize(formatters)
      @formatters = formatters
    end

    FORWARD_METHODS.each do |method|
      define_method(method) do |*args|
        formatters.map { |f| f.public_send(method, *args) }.last
      end
    end

    # SSHKit's formatters mutate the stdout and stderr data in the
    # command obj. So we need to dup it to ensure our copy is unscathed.
    DUP_AND_FORWARD_METHODS.each do |method|
      define_method(method) do |obj|
        formatters.map { |f| f.public_send(method, obj.dup) }.last
      end
    end
  end
end
