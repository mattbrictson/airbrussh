require "minitest_helper"
require "sshkit/formatter/airbrussh"
require_relative "../../airbrussh/formatter_test.rb"

# SSHKit::Formatter::Airbrussh should behave identically to
# Airbrussh::Formatter, so just reuse the Airbrussh::FormatterTest.
class SSHKit::Formatter::AirbrusshTest < Airbrussh::FormatterTest
  private

  def formatter_class
    SSHKit::Formatter::Airbrussh
  end
end
