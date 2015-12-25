require "airbrussh"
require "airbrussh/delegating_formatter"

# This is the formatter class that conforms to the SSHKit Formatter API and
# provides the airbrussh functionality to SSHKit. Note however that this class
# doesn't do much by itself; instead, it delegates to the ConsoleFormatter
# and (optionally) the LogFileFormatter, which handle the bulk of the logic.
#
module Airbrussh
  class Formatter < Airbrussh::DelegatingFormatter
    def initialize(io, options_or_config_object={})
      config = ::Airbrussh.configuration(options_or_config_object)
      # Delegate to ConsoleFormatter and (optionally) LogFileFormatter,
      # based on the configuration.
      super(config.formatters(io))
    end
  end
end
