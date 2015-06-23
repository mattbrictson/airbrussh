require "minitest_helper"

class Airbrussh::VersionTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Airbrussh::VERSION
  end
end
