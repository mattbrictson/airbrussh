# Airbrussh Change Log

All notable changes to this project will be documented in this file. This project adheres to [Semantic Versioning][Semver].

## [Unreleased]

* Your contribution here!

## [1.1.1][] (2016-09-09)

* When a Capistrano deploy fails and the error log is dumped to the console,
  Airbrussh no longer truncates the error output. This ensures that important
  troubleshooting information is not lost.
  [#91](https://github.com/mattbrictson/airbrussh/issues/91)

## [1.1.0][] (2016-07-26)

* Use default color for info messages.
  When using the `gray` color on some implementation of the `solarized`
  theme the text is not visible. The `solarized` theme is popular and
  bugs have been reported about missed error messages, so this patch
  switches these messages to the default color.
  (see [#84](https://github.com/mattbrictson/airbrussh/issues/84))

## [1.0.2][] (2016-05-13)

* Fix a crash that can happen in certain multi-server deployments when
  Capistrano's `invoke` is used to switch Rake tasks in the middle of SSHKit
  execution ([#78](https://github.com/mattbrictson/airbrussh/issues/78),
  [#80](https://github.com/mattbrictson/airbrussh/pull/80))

## [1.0.1][] (2016-03-21)

* Fix support for fake TTYs reporting a 0 width console like Ruby's PTY library [#76](https://github.com/mattbrictson/airbrussh/pull/76)

## [1.0.0][] (2016-02-27)

* No changes since 1.0.0.beta1.

## [1.0.0.beta1][] (2015-12-27)

Breaking Changes:

* None

Added:

* Airbrussh can now be configured with an options Hash passed to the
  `Airbrussh::Formatter` constructor. This is in order to standardize how all
  SSHKit formatters are configured
  (see [SSHKit #308](https://github.com/capistrano/sshkit/pull/308)).

## [0.8.0][] (2015-11-20)

* Airbrussh now displays the correct user@host output in the following edge-cases:
    * Inside an SSHKit `as(:user => "...")` block
    * When a user is specified using `set :ssh_options, :user => "..."` ([see #65](https://github.com/mattbrictson/airbrussh/issues/65))

## [0.7.0][] (2015-08-08)

Fixes:

* Handle truncation of raw/non-UTF8 output without crashing ([#57](https://github.com/mattbrictson/airbrussh/issues/57))

Other changes:

* Re-implement the "tail log on deploy failure" feature in pure Ruby ([#59](https://github.com/mattbrictson/airbrussh/issues/59))
* Code of contact added to the project
* Tests now run on Windows ([#55](https://github.com/mattbrictson/airbrussh/issues/55))

## [0.6.0][] (2015-07-10)

This is another release with mostly behind-the-scenes changes. If you notice any differences in Airbrussh's behavior in this version, [please report an issue](https://github.com/mattbrictson/airbrussh/issues).

Other changes:

* Bundler 1.10 is now required to build and test airbrussh (this doesn't affect users of airbrussh at all).
* If the directory containing the log file doesn't exist, Airbrussh will now attempt to create it using `FileUtils.mkdir_p` ([#30](https://github.com/mattbrictson/airbrussh/issues/30))
* By default Airbrussh now always prints `Using airbrussh format.` when it starts up. In previous versions, a bug caused this message to sometimes not be shown. To change or disable this message, set the `banner` configuration option as explained in the README.

## [0.5.1][] (2015-06-24)

* Fix `NameError: uninitialized constant Airbrussh::SimpleDelegator`

## [0.5.0][] (2015-06-24)

There are no changes to the actual behavior and feature set of Airbrussh in this release.

There are, however, many behind-the-scenes changes and improvements to overall code quality. This release also adds support for upcoming versions of SSHKit.

* Added Rubocop enforcement to Travis
* Added Code Climate and Coveralls checks (see badges in the README)
* Airbrussh now has good test coverage, and is tested by Travis against a matrix of Ruby and SSHKit versions ([@robd](https://github.com/robd))
* Changes to support the new SSHKit formatter API, as introduced in [SSHKit #257](https://github.com/capistrano/sshkit/pull/257) ([@robd](https://github.com/robd))
* `Airbrussh.reset` has been removed
* Airbrussh now has its own ANSI color code; it no longer relies on a third-party gem (i.e. `colorize`)

## [0.4.1][] (2015-05-06)

* Fix `Marshal.dump` warnings by removing `deep_copy` workaround that it is no longer needed for the latest SSHKit ([#10](https://github.com/mattbrictson/airbrussh/issues/10)).

## [0.4.0][] (2015-05-03)

* Changes to ensure compatibility with the upcoming version of SSHKit ([ec3122b](https://github.com/mattbrictson/airbrussh/commit/ec3122b101de53f2304723da842d5c8b6f70f4f3)).
* Explicitly specify UTF-8 encoding for source files, for Ruby 1.9.3 compatibility ([#9](https://github.com/mattbrictson/airbrussh/issues/9)).

## [0.3.0][] (2015-03-28)

* New `config.banner` option allows startup message to be disabled or changed (suggestion from [@justindowning](https://github.com/justindowning))
* New `config.command_output` option gives full control of whether airbrussh shows or hides the stderr and stdout data received from remote commands; see the usage section of the README for further explanation (suggestion from [@carlesso](https://github.com/carlesso))

## [0.2.1][] (2015-03-02)

* Un-pin SSHKit dependency now that SSHKit 1.7.1 has been released.

## [0.2.0][] (2015-03-02)

* Pin SSHKit dependency at `~> 1.6.1` to avoid a [bug in 1.7.0](https://github.com/capistrano/sshkit/issues/226) that causes command exit statuses to be omitted from the log.

## 0.0.1 (2015-02-19)

* Initial release

[Semver]: http://semver.org
[Unreleased]: https://github.com/mattbrictson/airbrussh/compare/v1.1.1...HEAD
[1.1.1]: https://github.com/mattbrictson/airbrussh/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/mattbrictson/airbrussh/compare/v1.0.2...v1.1.0
[1.0.2]: https://github.com/mattbrictson/airbrussh/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/mattbrictson/airbrussh/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/mattbrictson/airbrussh/compare/v1.0.0.beta1...v1.0.0
[1.0.0.beta1]: https://github.com/mattbrictson/airbrussh/compare/v0.8.0...v1.0.0.beta1
[0.8.0]: https://github.com/mattbrictson/airbrussh/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/mattbrictson/airbrussh/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/mattbrictson/airbrussh/compare/v0.5.1...v0.6.0
[0.5.1]: https://github.com/mattbrictson/airbrussh/compare/v0.5.0...v0.5.1
[0.5.0]: https://github.com/mattbrictson/airbrussh/compare/v0.4.1...v0.5.0
[0.4.1]: https://github.com/mattbrictson/airbrussh/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/mattbrictson/airbrussh/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/mattbrictson/airbrussh/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/mattbrictson/airbrussh/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/mattbrictson/airbrussh/compare/v0.0.1...v0.2.0
