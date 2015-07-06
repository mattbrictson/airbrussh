require "minitest_helper"

class Airbrussh::FormatterTest < Minitest::Test
  def test_uses_formatters_from_configuration_object
    io = stub
    config = Airbrussh::Configuration.new
    config.expects(:formatters).with(io).returns([:fmt1, :fmt2])

    formatter = formatter_class.new(io, config)
    assert_equal([:fmt1, :fmt2], formatter.formatters)
  end

  private

  def formatter_class
    Airbrussh::Formatter
  end
end
