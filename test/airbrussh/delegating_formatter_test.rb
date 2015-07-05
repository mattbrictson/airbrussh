require "minitest_helper"
require "airbrussh/delegating_formatter"

class Airbrussh::DelegatingFormatterTest < Minitest::Test
  def setup
    @fmt_1 = stub
    @fmt_2 = stub
    @delegating = Airbrussh::DelegatingFormatter.new([@fmt_1, @fmt_2])
  end

  def test_forwards_logger_methods
    %w(fatal error warn info debug log).each do |method|
      @fmt_1.expects(method).with("string").returns(6)
      @fmt_2.expects(method).with("string").returns(6)
      result = @delegating.public_send(method, "string")
      assert_equal(6, result)
    end
  end

  def test_forwards_start_and_exit_methods
    %w(log_command_start log_command_exit).each do |method|
      @fmt_1.expects(method).with(:command).returns(nil)
      @fmt_2.expects(method).with(:command).returns(nil)
      result = @delegating.public_send(method, :command)
      assert_nil(result)
    end
  end

  def test_forwards_log_command_data
    @fmt_1.expects(:log_command_data).with(:command, :stdout, "a").returns(nil)
    @fmt_2.expects(:log_command_data).with(:command, :stdout, "a").returns(nil)
    result = @delegating.log_command_data(:command, :stdout, "a")
    assert_nil(result)
  end

  def test_forwards_io_methods
    %w(<< write).each do |method|
      @fmt_1.expects(method).with("hello").returns(5)
      @fmt_2.expects(method).with("hello").returns(5)
      result = @delegating.public_send(method, "hello")
      assert_equal(5, result)
    end
  end
end
