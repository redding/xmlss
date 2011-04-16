require 'examples/example_workbook'

class Simple < ExampleWorkbook
  def name; "simple"; end
  def build

    # add 1 row of simple data across 3 columns
    wksht = Xmlss::Worksheet.new('1 row, 3 columns')

    wksht.table.columns << Xmlss::Column.new
    wksht.table.columns << Xmlss::Column.new
    wksht.table.columns << Xmlss::Column.new
    wksht.table.columns << Xmlss::Column.new
    wksht.table.columns << Xmlss::Column.new

    row1 = Xmlss::Row.new

    # put data into the row (infer type)
    [1, "text", 123.45, "0001267", "$45.23"].each do |data|
      row1.cells << Xmlss::Cell.new({
        :data => Xmlss::Data.new(data)
      })
    end

    wksht.table.rows << row1
    self.worksheets << wksht

  end
end
Simple.new.to_file(:format)
