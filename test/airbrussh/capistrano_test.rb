require "minitest_helper"
require "airbrussh/capistrano"

# Note: because this test requires airbrussh/capistrano outside of a Capistrano
# environment, a WARNING... message will be printed to stderr. This message can
# be disregarded.

class Airbrussh::CapistranoTest < Minitest::Test
  def teardown
    Airbrussh::Rake::Context.current_task_name = nil
  end

  def test_defines_tasks
    assert_instance_of(Rake::Task, Rake.application["load:defaults"])
    assert_instance_of(Rake::Task, Rake.application["deploy:failed"])
  end

  def test_load_defaults_rake_task_delegates_to_tasks_instance
    Airbrussh::Capistrano::Tasks.any_instance.expects(:load_defaults)
    Rake.application["load:defaults"].execute
  end

  def test_deploy_failed_rake_task_delegates_to_tasks_instance
    Airbrussh::Capistrano::Tasks.any_instance.expects(:deploy_failed)
    Rake.application["deploy:failed"].execute
  end
end
