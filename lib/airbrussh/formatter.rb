# encoding: UTF-8
require "airbrussh/command_output"
require "airbrussh/command_with_data"
require "airbrussh/console"
require "colorize"
require "ostruct"
require "sshkit"

# rubocop:disable Metrics/ClassLength

module Airbrussh
  class Formatter < SSHKit::Formatter::Abstract
    class << self
      attr_accessor :current_rake_task

      def monkey_patch_rake_task!
        return unless Airbrussh.configuration.monkey_patch_rake
        return if @rake_patched

        eval(<<-EVAL)
          class ::Rake::Task
            alias_method :_original_execute_airbrussh, :execute
            def execute(args=nil)
              #{name}.current_rake_task = name
              _original_execute_airbrussh(args)
            end
          end
        EVAL

        @rake_patched = true
      end
    end

    def initialize(io)
      super

      self.class.monkey_patch_rake_task!

      @tasks = {}

      @log_file = config.log_file
      @log_file_formatter = create_log_file_formatter

      @console = Airbrussh::Console.new(original_output)
      write_log_file_delimiter
      write_banner
    end

    def create_log_file_formatter
      return SSHKit::Formatter::BlackHole.new(nil) if @log_file.nil?
      SSHKit::Formatter::Pretty.new(
        ::Logger.new(@log_file, 1, 20_971_520)
      )
    end

    def print_line(string)
      @console.print_line(string)
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
      @log_file_formatter.log_command_start(command)
      disabling_log_file { write(Airbrussh::CommandWithData.new(command)) }
    end

    def log_command_data(command, stream_type, line)
      @log_file_formatter.log_command_data(command, stream_type, line)

      command_with_data = Airbrussh::CommandWithData.new(command)
      command_with_data.public_send("#{stream_type}=", line)
      disabling_log_file { write(command_with_data) }
    end

    def log_command_exit(command)
      @log_file_formatter.log_command_exit(command)
      disabling_log_file { write(Airbrussh::CommandWithData.new(command)) }
    end

    def write(obj)
      # SSHKit's :pretty formatter mutates the stdout and stderr data in the
      # command obj. So we need to dup it to ensure our copy is unscathed.
      @log_file_formatter << obj.dup

      case obj
      when SSHKit::LogMessage then write_log_message(obj)
      else write_command(obj)
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

    def write_log_message(log_message)
      return unless log_message.verbosity >= SSHKit::Logger::INFO
      print_task_if_changed
      @console.print_line(light_black("      " + log_message.to_s))
    end

    def write_command(command)
      return unless command.verbosity > SSHKit::Logger::DEBUG

      print_task_if_changed

      ctx = context_for_command(command)
      number = format("%02d", ctx.number)

      if ctx.first_execution?
        description = yellow(ctx.shell_string)
        print_line "      #{number} #{description}"
      end

      write_command_output(command, number)

      if command.finished?
        status = format_command_completion_status(command, number)
        print_line "    #{status}"
      end
    end

    # Prints the data from the stdout and stderr streams of the given command,
    # but only if enabled (see Airbrussh::Configuration#command_output).
    def write_command_output(command, number)
      # Use a bit of meta-programming here, since stderr and stdout logic
      # are identical except for different method names.
      %w(stderr stdout).each do |stream|
        next unless config.public_send("command_output_#{stream}?")
        CommandOutput.for(command).each_line(stream) do |line|
          print_line "      #{number} #{line.chomp}"
        end
      end
    end

    def print_task_if_changed
      status = current_task_status
      return if !status.changed || status.task.empty?

      print_line "#{clock} #{blue(status.task)}"
    end

    def current_task_status
      task = self.class.current_rake_task.to_s
      if @tasks[task]
        changed = false
      else
        changed = true
        @tasks[task] = []
      end

      OpenStruct.new(
        :task => task,
        :commands => @tasks[task],
        :changed => changed
      )
    end

    def context_for_command(command)
      status = current_task_status
      task_commands = status.commands

      shell_string = command.to_s.sub(%r{^/usr/bin/env }, "")

      if task_commands.include?(shell_string)
        first_execution = false
      else
        first_execution = true
        task_commands << shell_string
      end

      number = task_commands.index(shell_string) + 1

      OpenStruct.new(
        :first_execution? => first_execution,
        :number => number,
        :shell_string => shell_string
      )
    end

    def format_command_completion_status(command, number)
      user = command.user { command.host.user }
      host = command.host.to_s
      user_at_host = [user, host].join("@")

      status = \
        if command.failure?
          red("✘ #{number} #{user_at_host} (see #{@log_file} for details)")
        else
          green("✔ #{number} #{user_at_host}")
        end

      runtime = light_black(format("%5.3fs", command.runtime))

      status + " " + runtime
    end

    def clock
      @start_at ||= Time.now
      duration = Time.now - @start_at

      minutes = (duration / 60).to_i
      seconds = (duration - minutes * 60).to_i

      format("%02d:%02d", minutes, seconds)
    end

    %w(light_black red blue green yellow).each do |color|
      define_method(color) do |string|
        string.to_s.colorize(color.to_sym)
      end
    end

    def config
      Airbrussh.configuration
    end

    def disabling_log_file
      orig_log_file_formatter = @log_file_formatter
      @log_file_formatter = []
      yield
    ensure
      @log_file_formatter = orig_log_file_formatter
    end
  end
end
