require "airbrussh/formatter"

# Capistrano's formatter configuration requires that the formatter class
# be in the SSHKit::Formatter namespace. So we declare
# SSHKit::Formatter::Airbrussh that simply functions as an alias for
# Airbrussh::Formatter.
module SSHKit
  module Formatter
    class Airbrussh < Airbrussh::Formatter
    end
  end
end
