source "https://rubygems.org"

# Specify your gem's dependencies in airbrussh.gemspec
gemspec

# Optional development dependencies; requires bundler >= 1.10.
# Note that these gems assume a Ruby 2.2 environment. Install them using:
#
# bundle install --with development
#
group :extras, :optional => true do
  gem "chandler"
  gem "guard", ">= 2.2.2"
  gem "guard-minitest"
  gem "rb-fsevent"
  gem "terminal-notifier-guard"
end

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
