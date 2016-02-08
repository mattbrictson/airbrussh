#!/usr/bin/env ruby
require "yaml"
require "English"

YAML.load_file(".travis.yml")["env"].each do |sshkit_version|
  puts "\e[0;34;49m== Running tests against #{sshkit_version} ==\e[0m"
  output = `#{sshkit_version} bundle update`
  raise "bundle update failed: #{output}" unless $CHILD_STATUS.success?
  system("#{sshkit_version} bundle exec rake test")
end

system("bundle exec rake rubocop")

at_exit do
  puts "\e[0;34;49m== Resetting sshkit ==\e[0m"
  system("bundle update")
end
