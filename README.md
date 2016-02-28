# Airbrussh

[![Gem Version](https://badge.fury.io/rb/airbrussh.svg)](http://badge.fury.io/rb/airbrussh)
[![Build Status](https://travis-ci.org/mattbrictson/airbrussh.svg?branch=master)](https://travis-ci.org/mattbrictson/airbrussh)
[![Build status](https://ci.appveyor.com/api/projects/status/h052rlq54sne3md6/branch/master?svg=true)](https://ci.appveyor.com/project/mattbrictson/airbrussh/branch/master)
[![Code Climate](https://codeclimate.com/github/mattbrictson/airbrussh/badges/gpa.svg)](https://codeclimate.com/github/mattbrictson/airbrussh)
[![Coverage Status](https://coveralls.io/repos/mattbrictson/airbrussh/badge.svg?branch=master)](https://coveralls.io/r/mattbrictson/airbrussh?branch=master)


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

For advanced usage, refer to the these sections below:

* [FAQ](#faq)
* [Advanced configuration](#advanced-configuration)
* [Usage outside of Capistrano](#usage-outside-of-capistrano)

## FAQ

**Airbrussh is not displaying the output of my commands! For example, I run `tail` in one of my capistrano tasks and airbrussh doesn't show anything. How do I fix this?**

For brevity, airbrussh mutes all output (stdout and stderr) of commands by default. To show all output, add this to your `deploy.rb` (see also the other [configuration options](#advanced-configuration) later in this README):

```ruby
Airbrussh.configure do |config|
  config.command_output = true
end
```

**Does airbrussh work with Capistrano 2?**

No, Capistrano 3 is required. We recommend Capistrano 3.4.0 or higher.

**Does airbrussh work with JRuby?**

JRuby is not officially supported or tested, but may work. You must disable automatic truncation to work around a known bug in the JRuby 9.0.1.0 standard library. See [#62](https://github.com/mattbrictson/airbrussh/issues/62) for more details.

```ruby
Airbrussh.configure do |config|
  # Disable automatic truncation for JRuby compatibility
  config.truncate = false
end
```

**I have a question that’s not answered here or elsewhere in the README.**

Please [open a GitHub issue](https://github.com/mattbrictson/airbrussh/issues/new) and we’ll be happy to help!

## Advanced configuration

Airbrussh can be configured by calling `Airbrussh.configure` in your `deploy.rb` file. You can do stage-specific configuration in e.g. `deploy/production.rb` as well. Here are the available options:

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

Airbrussh started life as custom logging code within the [capistrano-mb][] collection of opinionated Capistrano recipes. In February 2015, the logging code was refactored into a standalone gem with its own configuration and documentation, and renamed `airbrussh`. Now anyone can using SSHKit or Capistrano can safely plug it into their projects!

## Roadmap

Airbrussh now has a stable feature set, excellent test coverage, is being used for production deployments, and has reached 1.0.0! Work is [underway](https://github.com/capistrano/capistrano/pull/1541) to integrate Airbrussh with the next Capistrano release. If you have ideas for improvements to Airbrussh, please open a [GitHub issue](https://github.com/mattbrictson/airbrussh/issues/new).

## Contributing

Contributions are welcome! Read [CONTRIBUTING.md](CONTRIBUTING.md) to get started.

[capistrano-mb]: https://github.com/mattbrictson/capistrano-mb
