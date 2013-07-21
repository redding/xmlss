require "bundler/gem_tasks"

namespace :bench do

  desc "Run the bench script."
  task :run do
    require 'bench/bench_runner'
    XmlssBenchRunner.new(1000).run
  end

  desc "Run the profiler on 1000 rows."
  task :profiler do
    require 'bench/profiler_runner'

    runner = XmlssProfilerRunner.new(1000)
    runner.print_flat(STDOUT, :min_percent => 1)
  end

  desc "Run the example workbook builds."
  task :examples do
    require 'examples/simple'
    require 'examples/layout'
    require 'examples/text'
    require 'examples/styles'
  end

  desc "Run all the tests, then the profiler, then the bench."
  task :all do
    Rake::Task['test'].invoke
    puts
    Rake::Task['bench:profiler'].invoke
    puts
    Rake::Task['bench:run'].invoke
    puts
    Rake::Task['bench:examples'].invoke
  end

end

task :bench do
  Rake::Task['bench:run'].invoke
end

