module Airbrussh
  # A facade that provides access to stdout and stderr command output of
  # sshkit commands. This is needed to normalize the API differences in
  # various sshkit versions.
  class CommandOutput
    def self.for(command)
      if command.respond_to?(:clear_stdout_lines)
        Modern.new(command)
      else
        Legacy.new(command)
      end
    end

    attr_reader :command

    def initialize(command)
      @command = command
    end
  end

  class Legacy < CommandOutput
    # The stderr/stdout methods provided by the command object have the current
    # "chunk" as received over the wire. Since there may be more chunks
    # appended and we don't want to print duplicates, clear the current data.
    def each_line(stream, &block)
      output = command.public_send(stream)
      return if output.empty?
      output.lines.to_a.each(&block)
      command.public_send("#{stream}=", "")
    end
  end

  class Modern < CommandOutput
    # Newer versions of sshkit take care of clearing the output with the
    # clear_stdout_lines/clear_stderr_lines methods.
    def each_line(stream, &block)
      lines = command.public_send("clear_#{stream}_lines")
      return if lines.join.empty?
      lines.each(&block)
    end
  end
end
