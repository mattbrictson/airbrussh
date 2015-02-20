require "airbrussh/configuration"
require "airbrussh/formatter"
require "airbrussh/version"

module Airbrussh
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
