require "airbrussh/configuration"
require "airbrussh/formatter"
require "airbrussh/version"

module Airbrussh
  def self.configuration(options={})
    return options if options.is_a?(::Airbrussh::Configuration)
    @configuration ||= Configuration.new
    @configuration.apply_options(options)
  end

  def self.configure
    yield(configuration)
  end
end
