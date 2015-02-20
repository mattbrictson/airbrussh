# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "airbrussh/version"

Gem::Specification.new do |spec|
  spec.name          = "airbrussh"
  spec.version       = Airbrussh::VERSION
  spec.authors       = ["Matt Brictson"]
  spec.email         = ["airbrussh@mattbrictson.com"]
  spec.summary       = "Airbrussh pretties up your SSHKit and Capistrano output"
  spec.description   = "Airbrussh is a replacement log formatter for SSHKit "\
                       "that makes your Capistrano output much easier on the "\
                       "eyes. Just add it to your Capfile and enjoy concise, "\
                       "useful log output that is easy to read."
  spec.homepage      = "https://github.com/mattbrictson/airbrussh"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
end
