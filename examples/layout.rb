require 'examples/example_workbook'

# $ bundle exec ruby examples/layout.rb

ExampleWorkbook.new("layout") do

  worksheet('first') {

    #  | A | B | C | D |
    # 1| x | x | x | x |
    # 2|   x   | x | x |
    # 3| x |       | x |
    # 4| x |   x   | x |
    # 5| x |       | x |

    4.times { column }

    # row 1: one cell per column
    row {
      4.times do |i|
        cell(:index => i+1) { data "x" }
      end
    }

    # row 2: first cell colspan=2
    row {
      cell(:index => 1, :merge_across => 1) { data "x" }
      2.times do |i|
        cell(:index => i+3) { data "x" }
      end
    }

    # row 3,4,5: more complex merging
    # => row 3
    row {
      cell(:index => 1) { data "x" }
      cell(:index => 2, :merge_across => 1, :merge_down => 2) { data "x" }
      cell(:index => 4) { data "x" }
    }

    # => row 4
    row {
      cell(:index => 1) { data "x" }
      cell(:index => 4) { data "x" }
    }

    # => row 5
    row {
      cell(:index => 1) { data "x" }
      cell(:index => 4) { data "x" }
    }

  }

end
