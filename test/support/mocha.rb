require "mocha/minitest"

Mocha.configure do |c|
  c.stubbing_non_existent_method = :warn
  c.stubbing_non_public_method = :warn
end
