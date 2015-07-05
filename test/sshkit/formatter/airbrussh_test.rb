require "minitest_helper"
require "sshkit/formatter/airbrussh"

class SSHKit::Formatter::AirbrusshTest < Minitest::Test
  def test_uses_formatters_from_configuration_object
    io = stub
    config = Airbrussh::Configuration.new
    config.expects(:formatters).with(io).returns([:fmt1, :fmt2])

    formatter = SSHKit::Formatter::Airbrussh.new(io, config)
    assert_equal([:fmt1, :fmt2], formatter.formatters)
  end
end
