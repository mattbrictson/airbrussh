require "minitest_helper"
require "airbrussh/colors"
require "forwardable"

class Airbrussh::ColorsTest < Minitest::Test
  extend Forwardable
  def_delegators :@colors, *Airbrussh::Colors.names

  def test_red
    enable_color
    assert_equal("\e[0;31;49mhello\e[0m", red("hello"))
  end

  def test_green
    enable_color
    assert_equal("\e[0;32;49mhello\e[0m", green("hello"))
  end

  def test_yellow
    enable_color
    assert_equal("\e[0;33;49mhello\e[0m", yellow("hello"))
  end

  def test_blue
    enable_color
    assert_equal("\e[0;34;49mhello\e[0m", blue("hello"))
  end

  def test_gray
    enable_color
    assert_equal("\e[0;90;49mhello\e[0m", gray("hello"))
  end

  def test_red_disabled
    enable_color(false)
    assert_equal("hello", red("hello"))
  end

  def test_green_disabled
    enable_color(false)
    assert_equal("hello", green("hello"))
  end

  def test_yellow_disabled
    enable_color(false)
    assert_equal("hello", yellow("hello"))
  end

  def test_blue_disabled
    enable_color(false)
    assert_equal("hello", blue("hello"))
  end

  def test_gray_disabled
    enable_color(false)
    assert_equal("hello", gray("hello"))
  end

  private

  def enable_color(enabled=true)
    @colors = Airbrussh::Colors.new(enabled)
  end
end
