require "mocha/mini_test"

Mocha::Configuration.warn_when(:stubbing_non_existent_method)
Mocha::Configuration.warn_when(:stubbing_non_public_method)
