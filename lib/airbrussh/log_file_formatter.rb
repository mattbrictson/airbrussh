require "delegate"
require "fileutils"
require "logger"
require "sshkit"

module Airbrussh
  # A Pretty formatter that sends its output to a specified log file path.
  # LogFileFormatter takes care of creating the file (and its parent
  # directory) if it does not already exist, opens it for appending, and writes
  # a delimiter message. The file is automatically rotated if it reaches 20 MB.
  #
  class LogFileFormatter < SimpleDelegator
    attr_reader :path

    def initialize(path, formatter_class=SSHKit::Formatter::Pretty)
      @path = path
      ensure_directory_exists if path.is_a?(String)
      super(formatter_class.new(log_file_io))
      write_delimiter
    end

    private

    def write_delimiter
      delimiter = []
      delimiter << "-" * 75
      delimiter << "START #{Time.now} cap #{ARGV.join(' ')}"
      delimiter << "-" * 75
      delimiter.each do |line|
        write(SSHKit::LogMessage.new(SSHKit::Logger::INFO, line))
      end
    end

    def ensure_directory_exists
      FileUtils.mkdir_p(File.dirname(path))
    end

    def log_file_io
      @io ||= ::Logger.new(path, 1, 20_971_520)
    end
  end
end
