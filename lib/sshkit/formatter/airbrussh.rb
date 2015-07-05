require "airbrussh"
require "airbrussh/delegating_formatter"

# Capistrano's formatter configuration requires that the formatter class
# be in the SSHKit::Formatter namespace.
module SSHKit
  module Formatter
    class Airbrussh < Airbrussh::DelegatingFormatter
      def initialize(io, config=::Airbrussh.configuration)
        super(config.formatters(io))
      end
    end
  end
end
