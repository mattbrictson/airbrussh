module Airbrussh
  module Rake
    # Decorates an SSHKit Command to add Rake-specific contextual information:
    #
    # * first_execution? - is this the first time this command has been run in
    #                      the context of the current rake task?
    # * position - zero-based position of this command in the list of
    #              all commands that have been run in the current rake task
    #
    class Command < SimpleDelegator
      attr_reader :first_execution, :position

      def initialize(command, first_execution, position)
        super(command)
        @first_execution = first_execution
        @position = position
      end

      def first_execution?
        first_execution
      end
    end
  end
end
