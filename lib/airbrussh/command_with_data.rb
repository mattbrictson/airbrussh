module Airbrussh
  # Decorate a Command to provide non deprecated stdout/stderr accessors.
  class CommandWithData < SimpleDelegator
    attr_accessor :stderr, :stdout

    def initialize(command)
      super
      @stderr = ""
      @stdout = ""
    end
  end
end
