require 'examples/example_workbook'

class Styles < ExampleWorkbook
  def name; "styles"; end
  def build

    wksht = Xmlss::Worksheet.new('styles')
    wksht.table.columns << Xmlss::Column.new

    self.styles << Xmlss::Style::Base.new('centered') do
      alignment(
        :horizontal => :center,
        :vertical => :center
      )
    end
    wksht.table.rows << Xmlss::Row.new
    wksht.table.rows[0].cells << Xmlss::Cell.new({
      :style_id => "centered",
      :data => Xmlss::Data.new("x")
    })

    self.styles << Xmlss::Style::Base.new('bordered') do
      alignment(:wrap_text => true)
      border(
        :position => :top,
        :weight => :hairline,
        :line_style => :continuous
      )
      border(
        :position => :right,
        :weight => :medium,
        :line_style => :continuous
      )
      border(
        :position => :bottom,
        :weight => :thick,
        :line_style => :dash_dot,
        :color => '#00FF00'
      )
      border(
        :position => :left,
        :weight => :thin,
        :line_style => :dot
      )
    end
    wksht.table.rows << Xmlss::Row.new
    wksht.table.rows[1].cells << Xmlss::Cell.new({
      :style_id => "bordered",
      :data => Xmlss::Data.new(%{blah blah blah blah blah\nblah blah blah blah\nblah blah blah blah})
    })

    self.styles << Xmlss::Style::Base.new('fonted') do
      font(
        :bold => true,
        :color => "#FF0000",
        :italic => true,
        :size => 18,
        :strike_through => true,
        :underline => true
      )
    end
    wksht.table.rows << Xmlss::Row.new
    wksht.table.rows[2].cells << Xmlss::Cell.new({
      :style_id => "fonted",
      :data => Xmlss::Data.new("Cool Font Styles!!")
    })

    self.styles << Xmlss::Style::Base.new('interior') do
      interior(
        :color => "#FF0000",
        :pattern => :diag_cross,
        :pattern_color => '#00FFFF'
      )
      font(:color => "#FFFFFF")
    end
    wksht.table.rows << Xmlss::Row.new
    wksht.table.rows[3].cells << Xmlss::Cell.new({
      :style_id => "interior",
      :data => Xmlss::Data.new("Weird Styles Man...")
    })

    self.worksheets << wksht
  end
end
Styles.new.to_file
