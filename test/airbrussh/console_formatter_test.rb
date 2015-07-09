require "minitest_helper"
require "stringio"
require "airbrussh/configuration"
require "airbrussh/console_formatter"

# ConsoleFormatter is currently tested via a comprehensive acceptance-style
# test in Airbrussh::FormatterTest. Hence the lack of unit tests here, which
# would be redundant.
class Airbrussh::ConsoleFormatterTest < Minitest::Test
  def setup
    @config = Airbrussh::Configuration.new
    @config.banner = false
    @config.command_output = true
    @output = StringIO.new
    @formatter = Airbrussh::ConsoleFormatter.new(@output, @config)
  end

  # Make sure that command data containing two lines is formatted as two
  # indented lines.
  def test_log_command_data_with_multiline_string
    command = stub(:verbosity => SSHKit::Logger::INFO, :to_s => "greet")
    data = "hello\nworld\n"
    @formatter.log_command_start(command)
    @formatter.log_command_data(command, :stdout, data)
    assert_equal(
      "      01 greet\n"\
      "      01 hello\n"\
      "      01 world\n",
      output)
  end

  private

  def output
    @output.string
  end
end
