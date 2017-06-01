# Airbrussh

[![Gem Version](https://badge.fury.io/rb/airbrussh.svg)](http://badge.fury.io/rb/airbrussh)
[![Build Status](https://travis-ci.org/mattbrictson/airbrussh.svg?branch=master)](https://travis-ci.org/mattbrictson/airbrussh)
[![Build status](https://ci.appveyor.com/api/projects/status/h052rlq54sne3md6/branch/master?svg=true)](https://ci.appveyor.com/project/mattbrictson/airbrussh/branch/master)
[![Code Climate](https://codeclimate.com/github/mattbrictson/airbrussh/badges/gpa.svg)](https://codeclimate.com/github/mattbrictson/airbrussh)
[![Coverage Status](https://coveralls.io/repos/mattbrictson/airbrussh/badge.svg?branch=master)](https://coveralls.io/r/mattbrictson/airbrussh?branch=master)


Airbrussh is a concise log formatter for Capistrano and SSHKit. It displays well-formatted, useful log output that is easy to read. Airbrussh also saves Capistrano's verbose output to a separate log file just in case you need additional details for troubleshooting.

**As of April 2016, Airbrussh is bundled with Capistrano 3.5, and is Capistrano's default formatter! There is nothing additional to install or enable.** Continue reading to learn more about Airbrussh's features and configuration options.

If you aren't yet using Capistrano 3.5 (or wish to use Airbrussh with SSHKit directly), refer to the [advanced/legacy usage](#advancedlegacy-usage) section for installation instructions.

![Sample output](https://raw.github.com/mattbrictson/airbrussh/master/demo.gif)

For more details on how exactly Airbrussh affects Capistrano's output and the reasoning behind it, check out the blog post: [Introducing Airbrussh](https://mattbrictson.com/airbrussh).

-----

* [Usage](#usage)
* [Configuration](#configuration)
* [FAQ](#faq)
* [Advanced/legacy usage](#advancedlegacy-usage)

## Usage

Airbrussh is enabled by default in Capistrano 3.5 and newer. To manually enable Airbrussh (for example, when upgrading an existing project), set the Capistrano format like this:

```ruby
# In deploy.rb
set :format, :airbrussh
```

### What's displayed

When you run a Capistrano command, Airbrussh provides the following information in its output:

![Sample output](https://raw.github.com/mattbrictson/airbrussh/master/formatting.png)

* Name of Capistrano task being executed
* When each task started (minutes:seconds elapsed since the deploy began)
* The SSH command-line strings that are executed; for Capistrano tasks that involve running multiple commands, the numeric prefix indicates the command in the sequence, starting from `01`
* Stdout and stderr output from each command
* The duration of each command execution, per server

### What's *not* displayed

For brevity, Airbrussh does not show *everything* that Capistrano is doing. For example, it will omit Capistrano's `test` commands, which can be noisy and confusing. Airbrussh also hides things like environment variables, as well as `cd` and `env` invocations. To see a full audit of Capistrano's execution, including *exactly* what commands were run on each server, look at `log/capistrano.log`.

## Configuration

You can customize many aspects of Airbrussh's output. In Capistrano 3.5 and newer, this is done via the `:format_options` variable, like this:

```ruby
# Pass options to Airbrussh
set :format_options, color: false, truncate: 80
```

Here are the options you can use, and their effects (note that the defaults may be different depending on where Airbrussh is used; these are the defaults used by Capistrano 3.5):

|Option|Default|Usage|
|---|---|---|
|`banner`|`nil`|Provide a string (e.g. "Capistrano started!") that will be printed when Capistrano starts up.|
|`color`|`:auto`|Use `true` or `false` to enable or disable ansi color. If set to `:auto`, Airbrussh automatically uses color based on whether the output is a TTY, or if the SSHKIT_COLOR environment variable is set.|
|`command_output`|`true`|Set to `:stdout`, `:stderr`, or `true` to display the SSH output received via stdout, stderr, or both, respectively. Set to `false` to not show any SSH output, for a minimal look.|
|`log_file`|`log/capistrano.log`|Capistrano's verbose output is saved to this file to facilitate debugging. Set to `nil` to disable completely.|
|`truncate`|`:auto`|Set to a number (e.g. 80) to truncate the width of the output to that many characters, or `false` to disable truncation. If `:auto`, output is automatically truncated to the width of the terminal window, if it can be determined.|
|`task_prefix`|`nil`|A string to prefix to task output. Handy for output collapsing like [buildkite](https://buildkite.com/docs/builds/managing-log-output)'s `---` prefix|

## FAQ

**Airbrussh is not displaying the output of my commands! For example, I run `tail` in one of my capistrano tasks and airbrussh doesn't show anything. How do I fix this?**

Make sure Airbrussh is configured to show SSH output.

```ruby
set :format_options, command_output: true
```

**I haven't upgraded to Capistrano 3.5 yet. Can I still use Airbrussh?**

Yes! Capistrano 3.4.x is also supported. Refer to the [advanced/legacy usage](#advancedlegacy-usage) section for installation instructions.

**Does Airbrussh work with Capistrano 2?**

No, Capistrano 3 is required. We recommend Capistrano 3.4.0 or higher. Capistrano 3.5.0 and higher have Airbrussh enabled by default, with no installation needed.

**Does Airbrussh work with JRuby?**

JRuby is not officially supported or tested, but may work. You must disable automatic truncation to work around a known bug in the JRuby 9.0 standard library. See [#62](https://github.com/mattbrictson/airbrussh/issues/62) for more details.

```ruby
set :format_options, truncate: false
```

**I have a question that’s not answered here or elsewhere in the README.**

Please [open a GitHub issue](https://github.com/mattbrictson/airbrussh/issues/new) and we’ll be happy to help!

## Advanced/legacy usage

Although Airbrussh is built into Capistrano 3.5.0 and higher, it is also available as a plug-in for older versions. Airbrussh has been tested with MRI 1.9+, Capistrano 3.4.0+, and SSHKit 1.6.1+.

### Capistrano 3.4.x

Add this line to your application's Gemfile:

```ruby
gem "airbrussh", require: false
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

Capistrano 3.4.x doesn't have the `:format_options` configuration system, so you will need to configure Airbrussh using this technique:

```ruby
Airbrussh.configure do |config|
  config.color = false
  config.command_output = true
  # etc.
end
```

Refer to the [configuration](#configuration) section above for the list of supported options.

### SSHKit

If you are using SSHKit directly (i.e. without Capistrano), you can use Airbrussh like this:

```ruby
require "airbrussh"
SSHKit.config.output = Airbrussh::Formatter.new($stdout)

# You can also pass configuration options like this
SSHKit.config.output = Airbrussh::Formatter.new($stdout, color: false)
```

## History

Airbrussh started life as custom logging code within the [capistrano-mb][] collection of opinionated Capistrano recipes. In February 2015, the logging code was refactored into a standalone gem with its own configuration and documentation, and renamed `airbrussh`. In February 2016, Airbrussh was added as the default formatter in Capistrano 3.5.0.

## Roadmap

Airbrussh now has a stable feature set, excellent test coverage, is being used for production deployments, and has reached 1.0.0! If you have ideas for improvements to Airbrussh, please open a [GitHub issue](https://github.com/mattbrictson/airbrussh/issues/new).

## Contributing

Contributions are welcome! Read [CONTRIBUTING.md](CONTRIBUTING.md) to get started.

[capistrano-mb]: https://github.com/mattbrictson/capistrano-mb
