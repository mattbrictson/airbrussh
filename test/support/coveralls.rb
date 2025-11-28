if ENV["CI"]
  begin
    require "simplecov"
    require "coveralls"

    SimpleCov.formatter = Coveralls::SimpleCov::Formatter
    SimpleCov.start do
      # No need to report coverage metrics for the test code
      add_filter "test"
    end
  rescue LoadError
    # ignore
  end
end
