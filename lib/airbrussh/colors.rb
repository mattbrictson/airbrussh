module Airbrussh
  # Very basic support for ANSI color, so that we don't have to rely on
  # any external dependencies.
  module Colors
    ANSI_CODES = {
      :red    => 31,
      :green  => 32,
      :yellow => 33,
      :blue   => 34,
      :gray   => 90
    }.freeze

    # Define red, green, blue, etc. methods that return a copy of the
    # String that is wrapped in the corresponding ANSI color escape
    # sequence.
    ANSI_CODES.each do |name, code|
      define_method(name) do |string|
        "\e[0;#{code};49m#{string}\e[0m"
      end
      module_function(name)
    end
  end
end
