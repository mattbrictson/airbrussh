# encoding: UTF-8
require "minitest_helper"
require "ostruct"
require "airbrussh/command_formatter"

class Airbrussh::CommandFormatterTest < Minitest::Test
  def setup
    @sshkit_command = OpenStruct.new(
      :host => host("deployer", "12.34.56.78"),
      :options => { :user => "override" },
      :runtime => 1.23456,
      :failure? => false
    )
    @sshkit_command.define_singleton_method(:to_s) do
      "/usr/bin/env echo hello"
    end
    @command = Airbrussh::CommandFormatter.new(@sshkit_command, 0)
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

  def test_uses_ssh_options_if_host_user_is_absent
    @sshkit_command.host = host(nil, "12.34.56.78", :user => "sshuser")
    assert_equal(
      "\e[0;32;49m✔ 01 sshuser@12.34.56.78\e[0m \e[0;90;49m1.235s\e[0m",
      @command.exit_message)
  end

  def test_shows_hostname_only_if_no_user
    @sshkit_command.host = host(nil, "12.34.56.78")
    assert_equal(
      "\e[0;32;49m✔ 01 12.34.56.78\e[0m \e[0;90;49m1.235s\e[0m",
      @command.exit_message)
  end

  private

  def host(user, hostname, ssh_options={})
    SSHKit::Host.new(
      :user => user,
      :hostname => hostname,
      :ssh_options => ssh_options
    )
  end
end
