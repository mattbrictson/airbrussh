require "minitest_helper"
require "airbrussh/log_file_formatter"
require "fileutils"
require "tempfile"

class Airbrussh::LogFileFormatterTest < Minitest::Test
  def setup
    @file = Tempfile.new("airbrussh-test-")
    @file.puts("Existing data")
    @file.close
    @formatter = Airbrussh::LogFileFormatter.new(@file.path)
  end

  def teardown
    @file.unlink
    @output = nil
  end

  def test_appends_to_existing_file
    assert_match("Existing data", output)
  end

  def test_writes_delimiter
    assert_match("----------", output)
    assert_match("START", output)
  end

  def test_writes_through_via_pretty_formatter
    @formatter << SSHKit::LogMessage.new(SSHKit::Logger::INFO, "hello")
    assert_match(/INFO.*hello/, output)
  end

  def test_creates_log_directory_and_file
    with_tempdir do |dir|
      log_file = File.join(dir, "log", "capistrano.log")
      Airbrussh::LogFileFormatter.new(log_file)
      assert(File.exist?(log_file))
    end
  end

  private

  def output
    @output ||= IO.read(@file.path)
  end

  def with_tempdir
    dir = Dir.mktmpdir("airbrussh-test-")
    yield(dir)
  ensure
    FileUtils.rm_rf(dir)
  end
end
