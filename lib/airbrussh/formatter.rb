require "airbrussh/colors"
require "airbrussh/command_formatter"
require "airbrussh/console"
require "airbrussh/rake/command"
require "airbrussh/rake/context"
require "sshkit"

module Airbrussh
  class Formatter < SSHKit::Formatter::Abstract
    include Airbrussh::Colors
    extend Forwardable

    attr_reader :config, :context
    def_delegator :context, :current_task_name

    def initialize(io, config=Airbrussh.configuration)
      super(io)

      @config = config
      @context = Airbrussh::Rake::Context.new(config)

      @log_file = config.log_file
      @log_file_formatter = create_log_file_formatter

      @console = Airbrussh::Console.new(original_output, config)
      write_log_file_delimiter
      write_banner
    end

    def create_log_file_formatter
      return SSHKit::Formatter::BlackHole.new(nil) if @log_file.nil?
      SSHKit::Formatter::Pretty.new(
        ::Logger.new(@log_file, 1, 20_971_520)
      )
    end

    def write_banner
      return unless config.banner
      if config.banner == :auto
        return if @log_file.nil?
        print_line "Using airbrussh format."
        print_line "Verbose output is being written to #{blue(@log_file)}."
      else
        print_line config.banner
      end
    end

    def write_log_file_delimiter
      delimiter = []
      delimiter << "-" * 75
      delimiter << "START #{Time.now} cap #{ARGV.join(' ')}"
      delimiter << "-" * 75
      delimiter.each do |line|
        @log_file_formatter << SSHKit::LogMessage.new(
          SSHKit::Logger::INFO,
          line
        )
      end
    end

    def log_command_start(command)
      command = decorate(command)
      @log_file_formatter.log_command_start(command)
      write_command_start(command)
    end

    def log_command_data(command, stream_type, line)
      command = decorate(command)
      @log_file_formatter.log_command_data(command, stream_type, line)
      write_command_output_line(command, stream_type, line)
    end

    def log_command_exit(command)
      command = decorate(command)
      @log_file_formatter.log_command_exit(command)
      write_command_exit(command)
    end

    def write(obj)
      # SSHKit's :pretty formatter mutates the stdout and stderr data in the
      # command obj. So we need to dup it to ensure our copy is unscathed.
      @log_file_formatter << obj.dup

      case obj
      when SSHKit::Command
        command = decorate(obj)
        write_command_start(command)
        write_command_output(command, :stderr)
        write_command_output(command, :stdout)
        write_command_exit(command) if command.finished?
      when SSHKit::LogMessage
        write_log_message(obj)
      end
    end
    alias_method :<<, :write

    def on_deploy_failure
      return if @log_file.nil?
      err = Airbrussh::Console.new($stderr)
      err.print_line
      err.print_line(red("** DEPLOY FAILED"))
      err.print_line(yellow("** Refer to #{@log_file} for details. "\
                            "Here are the last 20 lines:"))
      err.print_line
      system("tail -n 20 #{@log_file.shellescape} 1>&2")
    end

    private

    attr_accessor :last_printed_task

    def write_log_message(log_message)
      return if debug?(log_message)
      print_task_if_changed
      print_indented_line(gray(log_message.to_s))
    end

    def write_command_start(command)
      return if debug?(command)
      print_task_if_changed
      print_indented_line(command.start_message) if command.first_execution?
    end

    # For SSHKit versions up to and including 1.7.1, the stdout and stderr
    # output was available as attributes on the Command. Print the data for
    # the specified command and stream if enabled
    # (see Airbrussh::Configuration#command_output).
    def write_command_output(command, stream)
      output = command.public_send(stream)
      return if output.empty?
      output.lines.to_a.each do |line|
        write_command_output_line(command, stream, line)
      end
      command.public_send("#{stream}=", "")
    end

    def write_command_output_line(command, stream, line)
      hide_command_output = !config.public_send("command_output_#{stream}?")
      return if hide_command_output || debug?(command)
      print_indented_line(command.format_output(line))
    end

    def print_task_if_changed
      return if current_task_name.nil?
      return if current_task_name == last_printed_task

      self.last_printed_task = current_task_name
      print_line("#{clock} #{blue(current_task_name)}")
    end

    def write_command_exit(command)
      return if debug?(command)
      print_indented_line(command.exit_message(@log_file), -2)
    end

    def clock
      @start_at ||= Time.now
      duration = Time.now - @start_at

      minutes = (duration / 60).to_i
      seconds = (duration - minutes * 60).to_i

      format("%02d:%02d", minutes, seconds)
    end

    def debug?(obj)
      obj.verbosity <= SSHKit::Logger::DEBUG
    end

    def decorate(command)
      Airbrussh::CommandFormatter.new(@context.decorate_command(command))
    end

    def print_line(string)
      @console.print_line(string)
    end

    def print_indented_line(string, offset=0)
      indent = " " * (6 + offset)
      print_line([indent, string].join)
    end
  end
end
