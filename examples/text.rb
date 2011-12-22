require 'examples/example_workbook'

# $ bundle exec ruby examples/text.rb

ExampleWorkbook.new("text") do

  style 'general_text' do
    alignment(:horizontal => :left, :vertical => :top, :wrap_text => true)
    # set format to text explicitly
    number_format("@")
  end

  worksheet('text') do
    column

    row {
      cell(:style_id => "general_text") {
        data %{
A blob of text
with line breaks
  and leading space}
      }
    }
  end

end
