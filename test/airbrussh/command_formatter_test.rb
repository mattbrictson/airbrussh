# encoding: UTF-8
require "minitest_helper"
require "ostruct"
require "airbrussh/command_formatter"

class Airbrussh::CommandFormatterTest < Minitest::Test
  def setup
    sshkit_command = OpenStruct.new(
      :host => "12.34.56.78",
      :user => "deployer",
      :runtime => 1.23456,
      :failure? => false
    )
    def sshkit_command.to_s
      "/usr/bin/env echo hello"
    end
    @command = Airbrussh::CommandFormatter.new(sshkit_command, 0)
  end

  def test_format_output
    assert_equal("01 hello", @command.format_output("hello\n"))
  end

  def test_start_message
    assert_equal("01 \e[0;33;49mecho hello\e[0m", @command.start_message)
  end

  def test_exit_message_success
    assert_equal(
      "\e[0;32;49m✔ 01 deployer@12.34.56.78\e[0m \e[0;90;49m1.235s\e[0m",
      @command.exit_message)
  end

  def test_exit_message_failure
    @command.stub(:failure?, true) do
      assert_equal(
        "\e[0;31;49m✘ 01 deployer@12.34.56.78 (see out.log for details)\e[0m "\
        "\e[0;90;49m1.235s\e[0m",
        @command.exit_message("out.log"))
    end
  end
end
