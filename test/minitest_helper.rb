$LOAD_PATH.unshift(File.expand_path("../../lib", __FILE__))

# Coveralls has to be loaded first
require_relative("./support/coveralls")

# Load everything else from test/support
Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |rb| require(rb) }

require "airbrussh"
require "minitest/autorun"
