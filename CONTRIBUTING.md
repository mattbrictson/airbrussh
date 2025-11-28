# Contributing to airbrussh

Have a feature idea, bug fix, or refactoring suggestion? Contributions are welcome!

## Pull requests

1. Check [Issues][] to see if your contribution has already been discussed and/or implemented.
2. If not, open an issue to discuss your contribution. I won't accept all changes and do not want to waste your time.
3. Once you have the :thumbsup:, fork the repo, make your changes, and open a PR.

## Coding guidelines

* This project has a coding style enforced by [RuboCop][]. Use hash rockets and double-quoted strings, and otherwise try to follow the [Ruby style guide][style].
* Writing tests is strongly encouraged! This project uses Minitest.

## Getting started

After checking out the airbrussh repo, run `bin/setup` to install dependencies. Run `rake` to execute airbrussh's tests and RuboCop checks.

Airbrussh is designed to work against multiple versions of SSHKit and Ruby. In order to test this, we use the environment variable `sshkit` in order to run the tests against a specific version. The combinations of sshkit and ruby we support are specified in [.github/workflows/ci.yml](.github/workflows/ci.yml).

[Issues]: https://github.com/mattbrictson/airbrussh/issues
[RuboCop]: https://github.com/bbatsov/rubocop
[style]: https://github.com/bbatsov/ruby-style-guide
