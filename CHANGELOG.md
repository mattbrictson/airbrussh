## Next release

* Your contribution here!

## 0.3.0 (2015-03-28)

* New `config.banner` option allows startup message to be disabled or changed (suggestion from [@justindowning](https://github.com/justindowning))
* New `config.command_output` option gives full control of whether airbrussh shows or hides the stderr and stdout data received from remote commands; see the usage section of the README for further explanation (suggestion from [@carlesso](https://github.com/carlesso))

## 0.2.1 (2015-03-02)

* Un-pin SSHKit dependency now that SSHKit 1.7.1 has been released.

## 0.2.0 (2015-03-02)

* Pin SSHKit dependency at `~> 1.6.1` to avoid a [bug in 1.7.0](https://github.com/capistrano/sshkit/issues/226) that causes command exit statuses to be omitted from the log.

## 0.0.1 (2015-02-19)

* Initial release
