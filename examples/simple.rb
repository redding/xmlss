require 'rubygems'
require 'test/env'

puts "Builing simple.xml..."

class Simple < Xmlss::Workbook
  def initialize
    super
    build
  end

  def to_file
    # write this workbooks xml data to a file
    File.open("simple.xml", "w") do |file|
      file.write self.to_xml
    end
  end

  private

  def build
    # add 1 row of simple data across 3 columns
    wksht = Xmlss::Worksheet.new('1 row, 3 columns')

    wksht.table.columns << Xmlss::Column.new
    wksht.table.columns << Xmlss::Column.new
    wksht.table.columns << Xmlss::Column.new

    row1 = Xmlss::Row.new
    [1, "text", 123.45].each do |data|
      row1.cells << Xmlss::Cell.new({
        :data => Xmlss::Data.new(data)
      })
    end

    wksht.table.rows << row1
    self.worksheets << wksht
  end

end

Simple.new.to_file

puts "... ready - open Excel or whatever..."
