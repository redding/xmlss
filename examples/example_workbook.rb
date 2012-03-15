require 'xmlss'

class ExampleWorkbook < Xmlss::Workbook

  def initialize(name, &build)
    puts "Building #{name} workbook xml..."

    super(Xmlss::Writer.new(:pp => 2), &build)
    self.to_file("./examples/#{name}.xml")

    puts "... ready - open in Excel or whatever..."
  end

end

