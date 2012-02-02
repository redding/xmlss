require 'examples/example_workbook'

# $ bundle exec ruby examples/simple.rb

# create a workbook with 1 row and 5 columns
ExampleWorkbook.new("simple") do

  worksheet('1 row, 5 columns') {
    column
    column
    column
    column
    column

    row {

      # put data into the row (infer type)
      [1, "text", 123.45, "<>&'\"/", "$45.23"].each do |data_value|
        cell { data data_value }
      end

    }
  }

end
