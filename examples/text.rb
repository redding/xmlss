require 'examples/example_workbook'

class Text < ExampleWorkbook
  def name; "text"; end
  def build

    # add in general text style
    self.styles << Xmlss::Style::Base.new('general_text') do
      alignment(
        :horizontal => :left,
        :vertical => :top,
        :wrap_text => true
      )
      number_format(
        :format => "@"  # set format to text explicitly
      )
    end

    # add single cell with text data and specify general text style
    wksht = Xmlss::Worksheet.new('text')
    wksht.table.columns << Xmlss::Column.new
    row1 = Xmlss::Row.new
    row1.cells << Xmlss::Cell.new({
      :style_id => "general_text",
      :data => Xmlss::Data.new(%{
A blob of text
with line breaks
  and leading space
      })
    })
    wksht.table.rows << row1
    self.worksheets << wksht

  end
end
Text.new.to_file(:format)
