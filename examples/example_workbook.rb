require 'rubygems'
require 'test/env'

class ExampleWorkbook < Xmlss::Workbook
  def initialize
    super
    puts "Building #{self.name}.xml..."
    build
  end

  def to_file(*options)
    # write this workbooks xml data to a file
    File.open("examples/#{self.name}.xml", "w") do |file|
      file.write self.to_xml(*options)
    end
    puts "... ready - open in Excel or whatever..."
  end
end

