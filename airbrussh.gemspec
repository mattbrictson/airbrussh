# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "airbrussh/version"

Gem::Specification.new do |spec|
  spec.name          = "airbrussh"
  spec.version       = Airbrussh::VERSION
  spec.license       = "MIT"
  spec.authors       = ["Matt Brictson"]
  spec.email         = ["airbrussh@mattbrictson.com"]
  spec.summary       = "Airbrussh pretties up your SSHKit and Capistrano output"
  spec.description   = "A replacement log formatter for SSHKit that makes "\
                       "Capistrano output much easier on the eyes. Just add "\
                       "Airbrussh to your Capfile and enjoy concise, useful "\
                       "log output that is easy to read."
  spec.homepage      = "https://github.com/mattbrictson/airbrussh"
  spec.metadata      = {
    "bug_tracker_uri" => "https://github.com/mattbrictson/airbrussh/issues",
    "changelog_uri" => "https://github.com/mattbrictson/airbrussh/releases",
    "source_code_uri" => "https://github.com/mattbrictson/airbrussh",
    "homepage_uri" => "https://github.com/mattbrictson/airbrussh"
  }

  spec.files         = Dir.glob(%w[LICENSE.txt README.md {exe,lib}/**/*]).reject { |f| File.directory?(f) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sshkit", [">= 1.6.1", "!= 1.7.0"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "minitest", "~> 5.10"
  spec.add_development_dependency "minitest-reporters", "~> 1.1"
  spec.add_development_dependency "mocha", "~> 2.1"
end
