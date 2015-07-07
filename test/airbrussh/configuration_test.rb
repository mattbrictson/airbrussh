require "minitest_helper"
require "airbrussh/console_formatter"
require "airbrussh/log_file_formatter"
require "tempfile"

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

  def test_auto_banner_message_without_log
    @config.log_file = nil
    @config.banner = :auto
    assert_equal("Using airbrussh format.", @config.banner_message)
  end

  def test_auto_banner_message_with_log
    @config.log_file = "log/test.log"
    @config.banner = :auto
    assert_equal(
      "Using airbrussh format.\n"\
      "Verbose output is being written to \e[0;34;49mlog/test.log\e[0m.",
      @config.banner_message
    )
  end

  def test_nil_or_false_banner_message
    @config.banner = nil
    assert_nil(@config.banner_message)
    @config.banner = false
    assert_nil(@config.banner_message)
  end

  def test_custom_banner_message
    @config.banner = "Hello!"
    assert_equal("Hello!", @config.banner_message)
  end

  def test_formatters_without_log_file
    io = StringIO.new
    formatters = @config.formatters(io)
    assert_equal(1, formatters.length)
    assert_instance_of(Airbrussh::ConsoleFormatter, formatters.first)
    assert_equal(io, formatters.first.original_output)
    assert_equal(@config, formatters.first.config)
  end

  def test_formatters_with_log_file
    @config.log_file = Tempfile.new("airbrussh-test").path
    io = StringIO.new
    formatters = @config.formatters(io)
    assert_equal(2, formatters.length)
    assert_instance_of(Airbrussh::LogFileFormatter, formatters.first)
    assert_instance_of(Airbrussh::ConsoleFormatter, formatters.last)
    assert_equal(@config.log_file, formatters.first.path)
    assert_equal(io, formatters.last.original_output)
    assert_equal(@config, formatters.last.config)
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
