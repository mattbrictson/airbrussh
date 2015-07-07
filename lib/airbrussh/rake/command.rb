require "delegate"

module Airbrussh
  module Rake
    # Decorates an SSHKit Command to add Rake-specific contextual information:
    #
    # * position - zero-based position of this command in the list of
    #              all commands that have been run in the current rake task
    #
    class Command < SimpleDelegator
      attr_reader :position

      def initialize(command, position)
        super(command)
        @position = position
      end
    end
  end
end
