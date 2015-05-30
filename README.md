# Airbrussh

[![Gem Version](https://badge.fury.io/rb/airbrussh.svg)](http://badge.fury.io/rb/airbrussh)
[![Build Status](https://travis-ci.org/mattbrictson/airbrussh.svg?branch=master)](https://travis-ci.org/mattbrictson/airbrussh)


**Airbrussh is a replacement log formatter for SSHKit that makes your Capistrano output much easier on the eyes.** Just add it to your Capfile and enjoy concise, useful log output that is easy to read.

And don't worry: airbrussh saves Capistrano's default verbose output to a separate log file just in case you still need it for troubleshooting.

![Sample output](https://raw.github.com/mattbrictson/airbrussh/master/demo.gif)

For more details on how exactly Airbrussh changes Capistrano's output and the reasoning behind it, check out the blog post: [Introducing Airbrussh](https://mattbrictson.com/airbrussh).

## Requirements

**To use Airbrussh with Capistrano, you will need Capistrano 3.** Capistrano 2.x is not supported.

Airbrussh has been tested with MRI 1.9+, Capistrano 3.4.0, and SSHKit 1.6.1+. Refer to the [Travis configuration](.travis.yml) for our latest test matrix. If you run into trouble using airbrussh in your environment, [open an issue on GitHub](https://github.com/mattbrictson/airbrussh/issues/new).

Airbrussh's only dependency is SSHKit >= 1.6.1.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "airbrussh", :require => false
```

And then execute:

    $ bundle

Finally, add this line to your application's Capfile:

```ruby
require "airbrussh/capistrano"
```

**Important:** explicitly setting Capistrano's `:format` option in your deploy.rb will override airbrussh. Remove this line if you have it:

```ruby
# Remove this
set :format, :pretty
```

## Usage

Airbrussh automatically replaces the default Capistrano log formatter, so there is nothing more you have to do. Just run `cap` as normal and enjoy the prettier output!

**Advanced:** Airbrussh can be configured by calling `Airbrussh.configure` in your `deploy.rb` file. You can do stage-specific configuration in e.g. `deploy/production.rb` as well. Here are the available options:

```ruby
Airbrussh.configure do |config|
  # Capistrano's default, un-airbrusshed output is saved to a file to
  # facilitate debugging.
  #
  # To disable this entirely:
  # config.log_file = nil
  #
  # Default:
  config.log_file = "log/capistrano.log"

  # Airbrussh patches Rake so it can access the name of the currently executing
  # task. Set this to false if monkey patching is causing issues.
  #
  # Default:
  config.monkey_patch_rake = true

  # Ansi colors will be used in the output automatically based on whether the
  # output is a TTY, or if the SSHKIT_COLOR environment variable is set.
  #
  # To disable color always:
  # config.color = false
  #
  # Default:
  config.color = :auto

  # Output is automatically truncated to the width of the terminal window, if
  # possible. If the width of the terminal can't be determined, no truncation
  # is performed.
  #
  # To truncate to a fixed width:
  # config.truncate = 80
  #
  # Or to disable truncation entirely:
  # config.truncate = false
  #
  # Default:
  config.truncate = :auto

  # If a log_file is configured, airbrussh will output a message at startup
  # displaying the log_file location.
  #
  # To always disable this message:
  # config.banner = false
  #
  # To display an alternative message:
  # config.banner = "Hello, world!"
  #
  # Default:
  config.banner = :auto

  # You can control whether airbrussh shows the output of SSH commands. For
  # brevity, the output is hidden by default.
  #
  # Display stdout of SSH commands. Stderr is not displayed.
  # config.command_output = :stdout
  #
  # Display stderr of SSH commands. Stdout is not displayed.
  # config.command_output = :stderr
  #
  # Display all SSH command output.
  # config.command_output = [:stdout, :stderr]
  # or
  # config.command_output = true
  #
  # Default (all output suppressed):
  config.command_output = false
end
```

## Usage outside of Capistrano

If you are using SSHKit directly, you can use Airbrussh without the Capistrano magic:

```ruby
require "airbrussh"
SSHKit.config.output = Airbrussh::Formatter.new($stdout)
```

When Capistrano is not present, Airbrussh uses a slightly different default configuration:

```ruby
Airbrussh.configure do |config|
  config.log_file = nil
  config.monkey_patch_rake = false
  config.color = :auto
  config.truncate = :auto
  config.banner = :auto
  config.command_output = false
end
```

## History

Airbrussh started life as custom logging code within the [capistrano-fiftyfive][] collection of opinionated Capistrano recipes. In February 2015, the logging code was refactored into a standalone gem with its own configuration and documentation, and renamed `airbrussh`. Now anyone can using SSHKit or Capistrano can safely plug it into their projects!

## Roadmap

Airbrussh needs work! The first priority is to add tests. Once good test coverage is in place, some clean up and refactoring is needed to make the core formatting code easier to understand.

If you have ideas for other improvements, please contribute!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Airbrussh is designed to work against multiple versions of SSHKit and Ruby. In order to test this, we use the environment variable `sshkit` in order to run the tests against a specific version. The combinations of sshkit and ruby we support are specified in [.travis.yml](.travis.yml). To test all the versions locally, there is a `test_all.rb` bin file. This installs the gems and runs the tests for each sshkit version in [.travis.yml](.travis.yml). *Note: this will update your `Gemfile.lock` as each SSHKit gem version is installed. The gem version is restored to the default when the script exits.*

## Contributing

1. Fork it ( https://github.com/mattbrictson/airbrussh/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[capistrano-fiftyfive]: https://github.com/mattbrictson/capistrano-fiftyfive
