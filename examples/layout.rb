require 'examples/example_workbook'

class Layout < ExampleWorkbook
  def name; "layout"; end
  def build
    wksht = Xmlss::Worksheet.new('first')
    4.times do
      wksht.table.columns << Xmlss::Column.new
    end

    5.times do
      wksht.table.rows << Xmlss::Row.new
    end

    #  | A | B | C | D |
    # 1| x | x | x | x |
    # 2|   x   | x | x |
    # 3| x |       | x |
    # 4| x |   x   | x |
    # 5| x |       | x |

    # row 1: one cell per column
    4.times do |i|
      wksht.table.rows[0].cells << Xmlss::Cell.new({
        :index => i+1,
        :data => Xmlss::Data.new("x")
      })
    end

    # row 2: first cell colspan=2
    wksht.table.rows[1].cells << Xmlss::Cell.new({
      :index => 1,
      :data => Xmlss::Data.new("x"),
      :merge_across => 1
    })
    2.times do |i|
      wksht.table.rows[1].cells << Xmlss::Cell.new({
        :index => i+3,
        :data => Xmlss::Data.new("x")
      })
    end

    # row 3,4,5: more complex merging
    # => row 3
    wksht.table.rows[2].cells << Xmlss::Cell.new({
      :data => Xmlss::Data.new("x"),
      :index => 1
    })
    wksht.table.rows[2].cells << Xmlss::Cell.new({
      :data => Xmlss::Data.new("x"),
      :merge_across => 1,
      :merge_down => 2,
      :index => 2
    })
    wksht.table.rows[2].cells << Xmlss::Cell.new({
      :data => Xmlss::Data.new("x"),
      :index => 4
    })
    # => row 4
    wksht.table.rows[3].cells << Xmlss::Cell.new({
      :data => Xmlss::Data.new("x"),
      :index => 1
    })
    wksht.table.rows[3].cells << Xmlss::Cell.new({
      :data => Xmlss::Data.new("x"),
      :index => 4
    })
    # => row 5
    wksht.table.rows[4].cells << Xmlss::Cell.new({
      :data => Xmlss::Data.new("x"),
      :index => 1
    })
    wksht.table.rows[4].cells << Xmlss::Cell.new({
      :data => Xmlss::Data.new("x"),
      :index => 4
    })

    self.worksheets << wksht
  end
end
Layout.new.to_file
