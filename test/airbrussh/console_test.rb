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
    assert_equal("The quick brown fo…\n", output)
  end

  def test_truncates_to_explicit_width
    console = configured_console(:tty => true) do |config|
      config.color = false
      config.truncate = 25
    end
    console.print_line("The quick brown fox jumps over the lazy dog.")
    assert_equal("The quick brown fox jum…\n", output)
  end

  def test_truncation_can_be_disabled
    console = configured_console(:tty => true) do |config|
      config.truncate = false
    end
    IO.expects(:console).never
    console.print_line("The quick brown fox jumps over the lazy dog.")
    assert_equal("The quick brown fox jumps over the lazy dog.\n", output)
  end

  # SSHKit sometimes returns raw ASCII-8BIT data that cannot be converted to
  # UTF-8, which could frustrate the truncation logic. Make sure that Console
  # recovers gracefully in this scenario.
  def test_truncates_improperly_encoded_ascii_string
    console = configured_console(:tty => true) do |config|
      config.color = false
      config.truncate = 10
    end

    console.print_line(ascii_8bit("The ‘quick’ brown fox"))

    # Note that the left-apostrophe character is actually 3 bytes as raw
    # ASCII-8BIT, which accounts for the short truncated value.
    assert_equal(ascii_8bit("The ‘...\n"), ascii_8bit(output))
  end

  def test_doesnt_truncates_to_zero_width
    console = configured_console(:tty => true) do |config|
      config.color = false
      config.truncate = 0
    end
    console.print_line("The quick brown fox jumps over the lazy dog.")
    assert_equal("The quick brown fox jumps over the lazy dog.\n", output)
  end

  def test_ellipsis_length_for_utf_8
    console = configured_console(:tty => true) do |config|
      config.color = :auto
    end
    results = console.ellipsis_length("…")
    assert_equal(2, results)
  end

  def test_ellipsis_length_string
    console = configured_console(:tty => true) do |config|
      config.color = :auto
    end
    results = console.ellipsis_length("...")
    assert_equal(3, results)
  end

  private

  def ascii_8bit(string)
    string.force_encoding("ASCII-8BIT")
  end

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
