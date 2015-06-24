require "minitest_helper"
require "airbrussh/colors"

class Airbrussh::ColorsTest < Minitest::Test
  include Airbrussh::Colors

  def test_red
    assert_equal("\e[0;31;49mhello\e[0m", red("hello"))
  end

  def test_green
    assert_equal("\e[0;32;49mhello\e[0m", green("hello"))
  end

  def test_yellow
    assert_equal("\e[0;33;49mhello\e[0m", yellow("hello"))
  end

  def test_blue
    assert_equal("\e[0;34;49mhello\e[0m", blue("hello"))
  end

  def test_gray
    assert_equal("\e[0;90;49mhello\e[0m", gray("hello"))
  end
end
