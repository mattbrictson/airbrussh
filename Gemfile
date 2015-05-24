source "https://rubygems.org"

# Specify your gem's dependencies in airbrussh.gemspec
gemspec

if (sshkit_version = ENV["sshkit"])
  requirement = begin
    Gem::Dependency.new("sshkit", sshkit_version).requirement
  rescue ArgumentError
    { :github => "capistrano/sshkit", :branch => sshkit_version }
  end
  gem "sshkit", requirement
end
