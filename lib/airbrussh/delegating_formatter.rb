require "sshkit"

module Airbrussh
  class DelegatingFormatter
    FORWARDED_METHODS = %w(
      fatal error warn info debug log
      log_command_start log_command_data log_command_exit
      << write
    )

    attr_reader :formatters

    def initialize(formatters)
      @formatters = formatters
    end

    FORWARDED_METHODS.each do |method|
      define_method(method) do |*args|
        formatters.map { |f| f.public_send(method, *args) }.last
      end
    end
  end
end
