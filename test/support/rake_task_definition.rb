module RakeTaskDefinition
  def define_and_execute_rake_task(task_name, &block)
    task_name ||= RakeTaskDefinition.unique_task_name(name)
    Rake::Task.define_task(task_name, &block).execute
  end

  def self.unique_task_name(test_name)
    @task_index ||= 0
    "#{test_name}_#{@task_index += 1}"
  end
end
