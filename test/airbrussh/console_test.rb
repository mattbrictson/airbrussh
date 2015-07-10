# encoding: UTF-8

require "minitest_helper"
require "stringio"
require "airbrussh/configuration"
require "airbrussh/console"

class Airbrussh::ConsoleTest < Minitest::Test
  def setup
    @output = StringIO.new
  end

  def test_color_is_allowed_for_tty
    console = configured_console(:tty => true) do |config|
      config.color = :auto
    end
    console.print_line("The \e[0;32;49mgreen\e[0m text")
    assert_equal("The \e[0;32;49mgreen\e[0m text\n", output)
  end

  def test_color_is_can_be_forced
    console = configured_console(:tty => false) do |config|
      config.color = true
    end
    console.print_line("The \e[0;32;49mgreen\e[0m text")
    assert_equal("The \e[0;32;49mgreen\e[0m text\n", output)
  end

  def test_color_is_can_be_forced_via_env
    console = configured_console(:tty => false) do |config|
      config.color = :auto
    end
    ENV.stubs(:[]).with("SSHKIT_COLOR").returns("1")
    console.print_line("The \e[0;32;49mgreen\e[0m text")
    assert_equal("The \e[0;32;49mgreen\e[0m text\n", output)
  end

  def test_color_is_stripped_for_non_tty
    console = configured_console(:tty => false) do |config|
      config.color = :auto
    end
    console.print_line("The \e[0;32;49mgreen\e[0m text")
    assert_equal("The green text\n", output)
  end

  def test_color_can_be_disabled_for_tty
    console = configured_console(:tty => true) do |config|
      config.color = false
    end
    console.print_line("The \e[0;32;49mgreen\e[0m text")
    assert_equal("The green text\n", output)
  end

  def test_truncates_to_winsize
    console = configured_console(:tty => true) do |config|
      config.color = false
      config.truncate = :auto
    end
    IO.stubs(:console => stub(:winsize => [100, 20]))
    console.print_line("The quick brown fox jumps over the lazy dog.")
    assert_equal("The quick brown fox…\n", output)
  end

  def test_truncates_to_explicit_width
    console = configured_console(:tty => true) do |config|
      config.color = false
      config.truncate = 25
    end
    console.print_line("The quick brown fox jumps over the lazy dog.")
    assert_equal("The quick brown fox jump…\n", output)
  end

  def test_truncation_can_be_disabled
    console = configured_console(:tty => true) do |config|
      config.truncate = false
    end
    IO.expects(:console).never
    console.print_line("The quick brown fox jumps over the lazy dog.")
    assert_equal("The quick brown fox jumps over the lazy dog.\n", output)
  end

  private

  def output
    @output.string
  end

  def configured_console(opts={})
    config = Airbrussh::Configuration.new
    yield(config) if block_given?
    @output.stubs(:tty? => opts.fetch(:tty, false))
    Airbrussh::Console.new(@output, config)
  end
end
