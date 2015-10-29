module Airbrussh
  # Very basic support for ANSI color, so that we don't have to rely on
  # any external dependencies.
  class Colors
    ANSI_CODES = {
      :black   => 30,
      :red     => 31,
      :green   => 32,
      :yellow  => 33,
      :blue    => 34,
      :magenta => 35,
      :cyan    => 36,
      :white   => 37,
      :gray    => 90,
      :light_black   => 90,
      :light_red     => 91,
      :light_green   => 92,
      :light_yellow  => 93,
      :light_blue    => 94,
      :light_magenta => 95,
      :light_cyan    => 96,
      :light_white   => 97
    }.freeze

    def self.names
      ANSI_CODES.keys
    end

    def initialize(enabled=true)
      @enabled = enabled
    end

    def enabled?
      @enabled
    end

    # Define red, green, blue, etc. methods that return a copy of the
    # String that is wrapped in the corresponding ANSI color escape
    # sequence.
    ANSI_CODES.each do |name, code|
      define_method(name) do |string|
        return string.to_s unless enabled?
        "\e[0;#{code};49m#{string}\e[0m"
      end
    end
  end
end
