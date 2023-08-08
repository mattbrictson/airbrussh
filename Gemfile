source "https://rubygems.org"

# Specify your gem's dependencies in airbrussh.gemspec
gemspec

if RUBY_VERSION == "1.9.3"
  # These gems need specific version for Ruby 1.9
  gem "json", "~> 1.8"
  gem "minitest", "~> 5.11.3"
  gem "mocha", "~> 1.2"
  gem "net-ssh", "~> 2.8"
  gem "rake", "< 12.3"
  gem "term-ansicolor", "~> 1.3.2"
  gem "tins", "~> 1.6.0"
elsif RUBY_VERSION < "2.6"
  # These gems need specific versions for Ruby < 2.6
  gem "minitest", "< 5.16" # rubocop:disable Bundler/DuplicatedGem
  gem "net-ssh", "< 7" # rubocop:disable Bundler/DuplicatedGem
end

if RUBY_VERSION >= "2.5"
  # These gems need at least Ruby 2.5
  gem "coveralls_reborn", "~> 0.24.0"
end

if RUBY_VERSION >= "2.5"
  # These gems need at least Ruby 2.5
  gem "rubocop", "0.50.0"

  # Optional development dependencies; requires bundler >= 1.10.
  # Note that these gems assume a Ruby 2.2 environment. Install them using:
  #
  # bundle install --with extras
  #
  group :extras, :optional => true do
    gem "guard", ">= 2.2.2"
    gem "guard-minitest"
    gem "rb-fsevent"
    gem "terminal-notifier-guard"
  end
end

# Needed to make rubocop 0.50.0 work on modern rubies
gem "safe_yaml" if RUBY_VERSION >= "3.1"

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
    { :git => "https://github.com/#{user}/sshkit.git", :branch => branch }
  end
  gem "sshkit", requirement
end
