require 'examples/example_workbook'

# $ bundle exec ruby examples/styles.rb

ExampleWorkbook.new("styles") do

  worksheet 'styles' do
    column

    style 'centered' do
      alignment(:horizontal => :center, :vertical => :center)
    end

    row {
      cell(:style_id => "centered") { data "x" }
    }

    style 'bordered' do
      alignment(:wrap_text => true)
      borders {
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
      }
    end

    row {
      cell(:style_id => "bordered") {
        data %{blah blah blah blah blah\nblah blah blah blah\nblah blah blah blah}
      }
    }

    style 'fonted' do
      font(
        :bold => true,
        :color => "#FF0000",
        :italic => true,
        :size => 18,
        :strike_through => true,
        :underline => true
      )
    end

    row {
      cell(:style_id => "fonted") { data "Cool Font Styles!!" }
    }

    style 'interior' do
      interior(
        :color => "#FF0000",
        :pattern => :diag_cross,
        :pattern_color => '#00FFFF'
      )
      font(:color => "#FFFFFF")
    end

    row {
      cell(:style_id => "interior") { data "Weird Styles Man..." }
    }

  end

end
