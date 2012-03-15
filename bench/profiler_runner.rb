require 'ruby-prof'
require 'xmlss'

class XmlssProfilerRunner

  attr_reader :result

  def initialize(n)
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

    @result = RubyProf.profile do
      Xmlss::Workbook.new(Xmlss::Writer.new(:pp => 2), &build).to_file("./bench/profiler_#{n}.xml")
    end

  end

  def print_flat(outstream, opts={})
    RubyProf::FlatPrinter.new(@result).print(outstream, opts)
    #RubyProf::GraphPrinter.new(@result).print(outstream, opts)
  end

  def print_graph(outstream, opts={})
    RubyProf::GraphPrinter.new(@result).print(outstream, opts)
  end

end
