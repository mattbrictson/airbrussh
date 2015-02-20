# Airbrussh

**Airbrussh is a replacement log formatter for SSHKit that makes your Capistrano output much easier on the eyes.** Just add it to your Capfile and enjoy concise, useful log output that is easy to read.

And don't worry: airbrussh saves Capistrano's default verbose output to a separate log file just in case you still need it for troubleshooting.

*TODO: animated GIF of airbrusshed output goes here!*

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
  # facilitate debugging. To disable this entirely:
  # config.log_file = nil
  # Default:
  config.log_file = "log/capistrano.log"

  # Airbrussh patches Rake so it can access the name of the currently executing
  # task. Set this to false if monkey patching is causing issues.
  # Default:
  config.monkey_patch_rake = true

  # Ansi colors will be used in the output automatically based on whether the
  # output is a TTY, or if the SSHKIT_COLOR environment variable is set.
  # To disable color always:
  # config.color = false
  # Default:
  config.color = :auto

  # Output is automatically truncated to the width of the terminal window, if
  # possible. If the width of the terminal can't be determined, no truncation
  # is performed. To truncate to a fixed with:
  # config.truncate = 80
  # Or to disable truncation entirely:
  # config.truncate = false
  # Default:
  config.truncate = :auto
end
```

## Usage outside of Capistrano

If you are using SSHKit directly, you can use Airbrussh without the Capistrano magic:

```ruby
require "airbrussh"
SSHKit.config.output = Airbrussh::Formatter.new
```

When Capistrano is not present, Airbrussh uses a slightly different default configuration:

```ruby
Airbrussh.configure do |config|
  config.log_file = nil
  config.monkey_patch_rake = false
  config.color = :auto
  config.truncate = :auto
end
```

## History

Airbrussh started life as custom logging code within the [capistrano-fiftyfive][] collection of opinionated Capistrano recipes. In February 2015, the logging code was refactored into a standalone gem with its own configuration and documentation, and renamed `airbrussh`. Now anyone can using SSHKit or Capistrano can safely plug it into their projects!

## Contributing

1. Fork it ( https://github.com/[my-github-username]/airbrussh/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[capistrano-fiftyfive]: https://github.com/mattbrictson/capistrano-fiftyfive
