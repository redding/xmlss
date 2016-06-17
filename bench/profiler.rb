# $ bundle exec ruby bench/profiler.rb

$LOAD_PATH.unshift(File.expand_path("../..", __FILE__))
require 'bench/profiler_runner'

runner = XmlssProfilerRunner.new(ARGV[0] ? ARGV[0].to_i : 1000)
runner.print_flat(STDOUT, :min_percent => 1)
