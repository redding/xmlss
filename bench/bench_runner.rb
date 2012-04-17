require 'whysoslow'
require 'xmlss'

class XmlssBenchRunner

  attr_reader :result

  def initialize(n)
    @build = Proc.new do
      Xmlss::Workbook.new(Xmlss::Writer.new(:pp => 2), &Proc.new do
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
      end).to_file("./bench/profiler_#{n}.xml")
    end

    @printer = Whysoslow::DefaultPrinter.new({
      :title => "#{n} rows",
      :verbose => true
    })

    @runner = Whysoslow::Runner.new(@printer)
  end

  def run
    @runner.run &@build
  end

end
