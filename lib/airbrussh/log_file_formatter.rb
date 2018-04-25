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
      ensure_log_directory_created if path.is_a?(String)
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

    def ensure_log_directory_created
      ensure_log_directory_name_free
      ensure_directory_exists
    end

    def ensure_log_directory_name_free
      return unless blocking_file?

      raise IOError,
            %W[#{File.dirname(path)} is already a file.\n
               We expect to create a directory with this name to log within.\n
               Use set :format_options log_file: a/different/path.log to change
               the log directory name or move this file
               before re-running again.].join(" ")
    end

    def blocking_file?
      File.file?(File.dirname(path))
    end

    def ensure_directory_exists
      FileUtils.mkdir_p(File.dirname(path))
    end

    def log_file_io
      @io ||= ::Logger.new(path, 1, 20_971_520)
    end
  end
end
