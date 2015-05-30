module Airbrussh
  # Decorate a Command to give it the legacy stdout/stderr accessors.
  class CommandWithData < SimpleDelegator
    attr_accessor :stderr, :stdout

    def initialize(command)
      super
      @stderr = ""
      @stdout = ""
    end
  end
end
