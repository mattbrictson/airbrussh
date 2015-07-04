require "minitest_helper"
require "rake"
require "stringio"
require "tempfile"

# Capistrano needs to be defined in order for airbrussh/capistrano to load,
# and it also expects there to be a `set` method.
module Capistrano
  module MockDSL
    class << self
      attr_accessor :set_args
    end

    def set(*args)
      Capistrano::MockDSL.set_args = args
    end
  end
end
include Capistrano::MockDSL

class Airbrussh::CapistranoTest < Minitest::Test
  def setup
    Rake::Task.clear
    load(File.expand_path("../../../lib/airbrussh/capistrano.rb", __FILE__))
    @stderr_orig = $stderr
    @stderr = StringIO.new
    $stderr = @stderr
  end

  def teardown
    $stderr = @stderr_orig
  end

  def test_configures_for_capistrano
    assert_equal("log/capistrano.log", Airbrussh.configuration.log_file)
    assert(Airbrussh.configuration.monkey_patch_rake)
    assert_equal(:auto, Airbrussh.configuration.color)
    assert_equal(:auto, Airbrussh.configuration.truncate)
    assert_equal(:auto, Airbrussh.configuration.banner)
    refute(Airbrussh.configuration.command_output)
  end

  def test_defines_tasks
    assert_instance_of(Rake::Task, Rake.application["load:defaults"])
    assert_instance_of(Rake::Task, Rake.application["deploy:failed"])
  end

  def test_sets_airbrussh_formatter_on_load_defaults
    load_defaults = Rake.application["load:defaults"]
    load_defaults.invoke
    assert_equal([:format, :airbrussh], Capistrano::MockDSL.set_args)
  end

  def test_prints_last_20_logfile_lines_on_deploy_failure
    log_file = Tempfile.new("airbrussh-test-")
    begin
      log_file.write((11..31).map { |i| "line #{i}\n" }.join)
      log_file.close

      Airbrussh.configuration.stubs(:log_file => log_file.path)
      Rake.application["deploy:failed"].invoke

      assert_match("DEPLOY FAILED", stderr)
      refute_match("line 11", stderr)
      (12..31).each { |i| assert_match("line #{i}", stderr) }
    ensure
      log_file.unlink
    end
  end

  def test_does_not_print_anything_on_deploy_failure_if_nil_logfile
    Airbrussh.configuration.stubs(:log_file => nil)
    Rake.application["deploy:failed"].invoke
    assert_empty(stderr)
  end

  private

  def stderr
    @stderr.string
  end
end
