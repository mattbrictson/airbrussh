#!/usr/bin/env ruby
require "yaml"
require "English"

ruby24 = Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.4.0")

YAML.load_file(".travis.yml")["env"].each do |sshkit_version|
  # Older versions of SSHKit don't work with Ruby 2.4, so skip those
  next if ruby24 && sshkit_version !~ /master/
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
