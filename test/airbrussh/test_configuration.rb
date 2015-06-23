require "minitest_helper"
require "airbrussh/configuration"

class TestConfiguration < Minitest::Test
  def setup
    # Reset any configuration changes done by the tests
    Airbrussh.reset
  end

  def test_default_command_output
    refute(config.command_output)
  end

  def test_effects_of_command_output_true
    config.command_output = true
    assert(config.command_output_stdout?)
    assert(config.command_output_stderr?)
  end

  def test_effects_of_command_output_false
    config.command_output = false
    refute(config.command_output_stdout?)
    refute(config.command_output_stderr?)
  end

  def test_effects_of_command_output_stdout
    config.command_output = :stdout
    assert(config.command_output_stdout?)
    refute(config.command_output_stderr?)
  end

  def test_effects_of_command_output_stderr
    config.command_output = :stderr
    refute(config.command_output_stdout?)
    assert(config.command_output_stderr?)
  end

  def test_effects_of_command_output_stdout_stderr
    config.command_output = [:stdout, :stderr]
    assert(config.command_output_stdout?)
    assert(config.command_output_stderr?)
  end

  private

  def config
    Airbrussh.configuration
  end
end
