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

  def test_errors_if_log_directory_cannot_be_created
    with_tempdir do |dir|
      FileUtils.touch(File.dirname(log_file_path(dir)))
      err = assert_raises(IOError) do
        Airbrussh::LogFileFormatter.new(log_file_path(dir))
      end
      assert_match(/log is already a file/, err.message)
    end
  end

  def test_creates_log_directory_and_file
    with_tempdir do |dir|
      Airbrussh::LogFileFormatter.new(log_file_path(dir))
      assert(File.exist?(log_file_path(dir)))
    end
  end

  private

  def output
    @output ||= IO.read(@file.path)
  end

  def log_file_path(dir)
    File.join(dir, "log", "capistrano.log")
  end

  def with_tempdir
    dir = Dir.mktmpdir("airbrussh-test-")
    yield(dir)
  ensure
    FileUtils.rm_rf(dir)
  end
end
