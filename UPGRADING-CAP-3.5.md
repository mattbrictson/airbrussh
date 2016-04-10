# Capistrano 3.5 upgrade guide for existing Airbrussh users

If you have been using Airbrussh with Capistrano, and are upgrading to Capistrano 3.5, then this guide is for you.

## What changed?

* Airbrussh is built into Capistrano starting with Capistrano 3.5.0, and is enabled by default.
* Capistrano 3.5 initializes Airbrussh with a default configuration that is different than Airbrussh+Capistrano 3.4.0.
* In Capistrano 3.5, `set :format_options, ...` is now the preferred mechanism for configuring Airbrussh.

## How to upgrade

1. Remove `gem "airbrussh"` from your Gemfile. Airbrussh is now included automatically by Capistrano.
2. Likewise, remove `require "capistrano/airbrussh"` from your Capfile. Capistrano now does this internally.
3. Remove `Airbrussh.configure do ... end` from your deploy.rb and replace with `set :format_options, ...` (see below).

## New configuration system

In Capistrano 3.5, Airbrussh is configured by assigning a configuration Hash to the `:format_options` variable. Here is a comparison of the old and new syntaxes:

```ruby
# Old syntax
Airbrussh.configure do |config|
  config.color = false
end

# New syntax
set :format_options, color: false
```

Although the syntax is different, the names of the configuration keys have not changed.

## New defaults

Capistrano 3.5.0 changes Airbrussh defaults as follows:

* `banner: false`
* `command_output: true`

Therefore, after upgrading to Capistrano 3.5.0, you may notice Airbrussh's output has changed and become more verbose. To restore the defaults to what you were used to in older versions, do this:

```ruby
set :format_options, banner: :auto, command_output: false
```

## Trouble?

If you have any Airbrussh-related trouble with the upgrade, please [open an issue](https://github.com/mattbrictson/airbrussh/issues).
