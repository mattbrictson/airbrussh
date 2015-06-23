require "minitest_helper"
require "airbrussh/rake/command"

class Airbrussh::Rake::CommandTest < Minitest::Test
  def setup
    original = %w(foo bar)
    @command = Airbrussh::Rake::Command.new(original, true, 1)
  end

  def test_delegates_to_original_object
    assert_equal("foo", @command.first)
    assert_equal("bar", @command.last)
  end

  def test_contextual_data
    assert(@command.first_execution?)
    assert_equal(1, @command.position)
  end
end
