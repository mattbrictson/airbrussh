require "minitest_helper"
require "airbrussh"

class TestVersion < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Airbrussh::VERSION
  end
end
