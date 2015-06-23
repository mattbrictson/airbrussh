require "minitest_helper"

class AirbrusshTest < Minitest::Test
  def test_configure_yields_config_object
    config = Airbrussh.configuration
    assert_equal(config, Airbrussh.configure { |c| c })
  end
end
