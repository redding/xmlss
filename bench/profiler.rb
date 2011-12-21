# $ bundle exec ruby bench/profiler.rb

require 'ruby-prof'
require 'xmlss'

n = ARGV[0] ? ARGV[0].to_i : 100
build = Proc.new do
  worksheet("5 columns, #{n} rows") {
    column
    column
    column
    column
    column

    n.times do |i|
      row {
        # put data into the row (infer type)
        [1, "text", 123.45, "0001267", "$45.23"].each do |data_value|
          cell { data data_value }
        end
      }
    end
  }
end

result = RubyProf.profile do
  Xmlss::Workbook.new(:output => {:pp => 2}, &build).to_file("./bench/profiler_#{n}.xml")
end

printer = RubyProf::FlatPrinter.new(result).print(STDOUT, :min_percent => 1)
# printer = RubyProf::GraphPrinter.new(result).print(STDOUT)
