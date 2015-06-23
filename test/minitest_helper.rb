$LOAD_PATH.unshift(File.expand_path("../../lib", __FILE__))

# Load test/support
Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |rb| require(rb) }

require "airbrussh"
require "minitest/autorun"
