# Contributing to airbrussh

Have a feature idea, bug fix, or refactoring suggestion? Contributions are welcome!

## Pull requests

1. Check [Issues][] to see if your contribution has already been discussed and/or implemented.
2. If not, open an issue to discuss your contribution. I won't accept all changes and do not want to waste your time.
3. Once you have the :thumbsup:, fork the repo, make your changes, and open a PR.
4. Don't forget to add your contribution and credit yourself in `CHANGELOG.md`!

## Coding guidelines

* This project has a coding style enforced by [RuboCop][]. Use hash rockets and double-quoted strings, and otherwise try to follow the [Ruby style guide][style].
* Writing tests is strongly encouraged! This project uses Minitest.

## Getting started

Note that Bundler 1.10 is required for development. Run `gem update bundler` to get the latest version.

After checking out the airbrussh repo, run `bin/setup` to install dependencies.

* `rake` executes airbrussh's tests and RuboCop checks
* `bin/test_all.rb` executes the tests against all versions of SSHKit that airbrussh supports

A Guardfile is also present, so if you'd like to use Guard to do a TDD workflow, then:

1. Run `bundle install --with extras` to get the optional guard dependencies
2. Run `guard` to monitor the filesystem and automatically run tests as you work

[Issues]: https://github.com/mattbrictson/airbrussh/issues
[RuboCop]: https://github.com/bbatsov/rubocop
[style]: https://github.com/bbatsov/ruby-style-guide
