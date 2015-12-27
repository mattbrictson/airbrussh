require "minitest_helper"

class AirbrusshTest < Minitest::Test
  def test_configure_yields_config_object
    config = Airbrussh.configuration
    assert_equal(config, Airbrussh.configure { |c| c })
  end

  def test_configuration_returns_passed_config
    config = Airbrussh::Configuration.new
    assert_equal(config, Airbrussh.configuration(config))
  end

  def test_configuration_applies_options
    config = Airbrussh.configuration(:banner => "test_success")
    assert_equal("test_success", config.banner)
    assert_equal("test_success", Airbrussh.configuration.banner)
  end
end
