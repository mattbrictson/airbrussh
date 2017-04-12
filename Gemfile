source "https://rubygems.org"

# Specify your gem's dependencies in airbrussh.gemspec
gemspec

# Optional development dependencies; requires bundler >= 1.10.
# Note that these gems assume a Ruby 2.2 environment. Install them using:
#
# bundle install --with extras
#
group :extras, :optional => true do
  gem "chandler"
  gem "guard", ">= 2.2.2"
  gem "guard-minitest"
  gem "rb-fsevent"
  gem "terminal-notifier-guard"
end

# Danger is used by Travis, but only for Ruby 2.0+
gem "danger", "~> 4.3" unless RUBY_VERSION == "1.9.3"

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

# json 2.0+ is not compatible with Ruby 1.9, so pin at older version.
gem "json", "~> 1.8" if RUBY_VERSION == "1.9.3"

# net-ssh 3.0+ is not compatible with Ruby 1.9, so pin at older version.
gem "net-ssh", "~> 2.8" if RUBY_VERSION == "1.9.3"

# term-ansicolor 1.4.0+ is not compatible with Ruby 1.9, so pin older version.
gem "term-ansicolor", "~> 1.3.2" if RUBY_VERSION == "1.9.3"

# tins 1.7.0+ is not compatible with Ruby 1.9, so pin at older version.
gem "tins", "~> 1.6.0" if RUBY_VERSION == "1.9.3"
