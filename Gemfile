source "https://rubygems.org"

# Specify your gem's dependencies in airbrussh.gemspec
gemspec

if (sshkit_version = ENV["sshkit"])
  requirement = begin
    Gem::Dependency.new("sshkit", sshkit_version).requirement
  rescue ArgumentError
    user, branch =
      if sshkit_version.include?("#")
        sshkit_version.split("#")
      else
        ["capistrano", sshkit_version]
      end
    { :github => "#{user}/sshkit", :branch => branch }
  end
  gem "sshkit", requirement
end
