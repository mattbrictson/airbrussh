require "airbrussh/colors"
require "airbrussh/command_formatter"
require "airbrussh/console"
require "airbrussh/rake/context"
require "forwardable"
require "sshkit"

module Airbrussh
  class ConsoleFormatter < SSHKit::Formatter::Abstract
    extend Forwardable
    def_delegators :@colors, *Airbrussh::Colors.names

    attr_reader :config, :context
    def_delegators :context, :current_task_name, :register_new_command

    def initialize(io, config=Airbrussh.configuration)
      super(io)

      @config = config
      @colors = config.colors(io)
      @context = Airbrussh::Rake::Context.new(config)
      @console = Airbrussh::Console.new(original_output, config)

      write_banner
    end

    def write_banner
      message = config.banner_message(original_output)
      print_line(message) if message
    end

    def log_command_start(command)
      return if debug?(command)
      first_execution = register_new_command(command)
      command = decorate(command)
      print_task_if_changed
      print_indented_line(command.start_message) if first_execution
    end

    def log_command_data(command, stream_type, string)
      return if debug?(command)
      return unless config.show_command_output?(stream_type)
      command = decorate(command)
      string.each_line do |line|
        print_indented_line(command.format_output(line))
      end
    end

    def log_command_exit(command)
      return if debug?(command)
      command = decorate(command)
      print_indented_line(command.exit_message(@log_file), -2)
    end

    def write(obj)
      case obj
      when SSHKit::Command
        log_command_start(obj)
        log_and_clear_command_output(obj, :stderr)
        log_and_clear_command_output(obj, :stdout)
        log_command_exit(obj) if obj.finished?
      when SSHKit::LogMessage
        write_log_message(obj)
      end
    end
    alias_method :<<, :write

    private

    attr_accessor :last_printed_task

    def write_log_message(log_message)
      return if debug?(log_message)
      print_task_if_changed
      print_indented_line(gray(log_message.to_s))
    end

    # For SSHKit versions up to and including 1.7.1, the stdout and stderr
    # output was available as attributes on the Command. Print the data for
    # the specified command and stream if enabled and clear the stream.
    # (see Airbrussh::Configuration#command_output).
    def log_and_clear_command_output(command, stream)
      output = command.public_send(stream)
      log_command_data(command, stream, output)
      command.public_send("#{stream}=", "")
    end

    def print_task_if_changed
      return if current_task_name.nil?
      return if current_task_name == last_printed_task

      self.last_printed_task = current_task_name
      print_line("#{clock} #{blue(current_task_name)}")
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
      Airbrussh::CommandFormatter.new(
        command,
        @context.position(command),
        @colors
      )
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
