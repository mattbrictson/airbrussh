require "minitest_helper"

class Airbrussh::ConfigurationTest < Minitest::Test
  def setup
    @config = Airbrussh::Configuration.new
  end

  def test_defaults
    assert_nil(@config.log_file)
    assert_equal(:auto, @config.color)
    assert_equal(:auto, @config.truncate)
    assert_equal(:auto, @config.banner)
    refute(@config.monkey_patch_rake)
    refute(@config.command_output)
  end

  def test_effects_of_command_output_true
    @config.command_output = true
    assert(@config.show_command_output?(:stdout))
    assert(@config.show_command_output?(:stderr))
  end

  def test_effects_of_command_output_false
    @config.command_output = false
    refute(@config.show_command_output?(:stdout))
    refute(@config.show_command_output?(:stderr))
  end

  def test_effects_of_command_output_stdout
    @config.command_output = :stdout
    assert(@config.show_command_output?(:stdout))
    refute(@config.show_command_output?(:stderr))
  end

  def test_effects_of_command_output_stderr
    @config.command_output = :stderr
    refute(@config.show_command_output?(:stdout))
    assert(@config.show_command_output?(:stderr))
  end

  def test_effects_of_command_output_stdout_stderr
    @config.command_output = [:stdout, :stderr]
    assert(@config.show_command_output?(:stdout))
    assert(@config.show_command_output?(:stderr))
  end
end
