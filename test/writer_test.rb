require 'assert'

require 'xmlss/writer'
require 'xmlss/workbook'

module Xmlss



  class BasicTests < Assert::Context
    desc "UndiesWriter"
    setup do
      @w = Writer.new
    end
    subject { @w }

    should have_readers :styles_markup, :worksheets_markup
    should have_instance_methods :write, :push, :pop, :flush, :workbook

    should have_instance_methods :style, :alignment, :borders, :border
    should have_instance_methods :font, :interior, :number_format, :protection

    should have_instance_methods :worksheet, :column, :row, :cell

    should "have empty markup by default" do
      assert_empty subject.worksheets_markup
      assert_empty subject.styles_markup
    end

    should "return itself when flushed" do
      assert_equal subject, subject.flush
    end

  end



  class AttrsHashTests < BasicTests
    desc "AttrsHash"
    before do
      @a = Writer::AttrsHash.new
    end
    subject { @a }

    should have_reader :raw
    should have_instance_methods :value, :bool

    should "by default have an empty raw hash" do
      assert_equal({}, subject.raw)
    end

    should "apply values to a raw hash with the writer namespace" do
      assert_equal({"#{Writer::SHEET_NS}:a" => 'b'}, subject.value('a', 'b').raw)
    end

    should "ignore nil values" do
      assert_equal({}, subject.value('a', nil).raw)
    end

    should "ignore empty string values" do
      assert_equal({}, subject.value('a', '').raw)
    end

    should "apply booleans as '1' and otherwise ignore" do
      assert_equal({}, subject.bool('a', false).raw)
      assert_equal({"#{Writer::SHEET_NS}:a" => 1}, subject.bool('a', true).raw)
    end

  end



  class StyleWritingTests < BasicTests

    should "write alignment markup" do
      subject.write(Xmlss::Style::Alignment.new({
        :wrap_text => true,
        :horizontal => :center,
        :vertical => :bottom,
        :rotate => 90
      }))
      subject.flush

      assert_equal(
        "<Alignment ss:Horizontal=\"Center\" ss:Rotate=\"90\" ss:Vertical=\"Bottom\" ss:WrapText=\"1\" />",
        subject.styles_markup.to_s
      )
    end

    should "write border markup" do
      subject.write(Xmlss::Style::Border.new({
        :color => '#FF0000',
        :position => :top,
        :weight => :thick,
        :line_style => :dot
      }))
      subject.flush

      assert_equal(
        "<Border ss:Color=\"#FF0000\" ss:LineStyle=\"Dot\" ss:Position=\"Top\" ss:Weight=\"3\" />",
        subject.styles_markup.to_s
      )
    end

    should "write border collection markup" do
      subject.write(Xmlss::Style::Borders.new)
      subject.push(:styles)

      subject.write(Xmlss::Style::Border.new({
        :color => '#FF0000',
        :position => :top
      }))

      subject.write(Xmlss::Style::Border.new({
        :position => :left
      }))

      subject.flush

      assert_equal(
        "<Borders><Border ss:Color=\"#FF0000\" ss:LineStyle=\"Continuous\" ss:Position=\"Top\" ss:Weight=\"1\" /><Border ss:LineStyle=\"Continuous\" ss:Position=\"Left\" ss:Weight=\"1\" /></Borders>",
        subject.styles_markup.to_s
      )
    end

    should "write font markup" do
      subject.write(Xmlss::Style::Font.new({
        :bold => true,
        :color => '#FF0000',
        :italic => true,
        :size => 10,
        :strike_through => true,
        :underline => :single,
        :alignment => :superscript,
        :name => 'Verdana'
      }))
      subject.flush

      assert_equal(
        "<Font ss:Bold=\"1\" ss:Color=\"#FF0000\" ss:FontName=\"Verdana\" ss:Italic=\"1\" ss:Size=\"10\" ss:StrikeThrough=\"1\" ss:Underline=\"Single\" ss:VerticalAlign=\"Superscript\" />",
        subject.styles_markup.to_s
      )
    end

    should "write interior markup" do
      subject.write(Xmlss::Style::Interior.new({
        :color => "#000000",
        :pattern => :solid,
        :pattern_color => "#FF0000"
      }))
      subject.flush

      assert_equal(
        "<Interior ss:Color=\"#000000\" ss:Pattern=\"Solid\" ss:PatternColor=\"#FF0000\" />",
        subject.styles_markup.to_s
      )
    end

    should "write number format markup" do
      subject.write(Xmlss::Style::NumberFormat.new("General"))
      subject.flush

      assert_equal(
        "<NumberFormat ss:Format=\"General\" />",
        subject.styles_markup.to_s
      )
    end

    should "write protection markup" do
      subject.write(Xmlss::Style::Protection.new(true))
      subject.flush

      assert_equal(
        "<Protection ss:Protect=\"1\" />",
        subject.styles_markup.to_s
      )
    end

    should "write full style markup" do
      subject.write(Xmlss::Style::Base.new(:write_markup_test))
      subject.push(:styles)

      subject.write(Xmlss::Style::Alignment.new({
        :horizontal => :left,
        :vertical => :center,
        :wrap_text => true
      }))

      subject.write(Xmlss::Style::Borders.new)
      subject.push(:styles)

      subject.write(Xmlss::Style::Border.new({:position => :left}))
      subject.write(Xmlss::Style::Border.new({:position => :right}))

      subject.pop(:styles)
      subject.write(Xmlss::Style::Font.new({:bold => true}))
      subject.write(Xmlss::Style::Interior.new({:color => "#000000"}))
      subject.write(Xmlss::Style::NumberFormat.new("General"))
      subject.write(Xmlss::Style::Protection.new(true))

      subject.flush

      assert_equal(
        "<Style ss:ID=\"write_markup_test\"><Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\" ss:WrapText=\"1\" /><Borders><Border ss:LineStyle=\"Continuous\" ss:Position=\"Left\" ss:Weight=\"1\" /><Border ss:LineStyle=\"Continuous\" ss:Position=\"Right\" ss:Weight=\"1\" /></Borders><Font ss:Bold=\"1\" /><Interior ss:Color=\"#000000\" /><NumberFormat ss:Format=\"General\" /><Protection ss:Protect=\"1\" /></Style>",
        subject.styles_markup.to_s
      )
    end

  end



  class WorksheetWritingTests < BasicTests
    desc "writing worksheet markup"

    should "write cell data markup" do
      subject.write(Xmlss::Element::Cell.new("some data"))
      subject.flush

      assert_equal(
        "<Cell><Data ss:Type=\"String\">some data</Data></Cell>",
        subject.worksheets_markup.to_s
      )
    end

    should "write cell data markup w/ \\n line breaks" do
      subject.write(Xmlss::Element::Cell.new("line\nbreak", :type => :string))
      subject.flush

      assert_equal "<Cell><Data ss:Type=\"String\">line#{Writer::LB}break</Data></Cell>", subject.worksheets_markup.to_s
    end

    should "write cell data markup w/ \\r line breaks" do
      subject.write(Xmlss::Element::Cell.new("line\rbreak", :type => :string))
      subject.flush

      assert_equal "<Cell><Data ss:Type=\"String\">line#{Writer::LB}break</Data></Cell>", subject.worksheets_markup.to_s
    end

    should "write cell data markup w/ \\r\\n line breaks" do
      subject.write(Xmlss::Element::Cell.new("line\r\nbreak", :type => :string))
      subject.flush

      assert_equal "<Cell><Data ss:Type=\"String\">line#{Writer::LB}break</Data></Cell>", subject.worksheets_markup.to_s
    end

    should "write cell data markup w/ \\n\\r line breaks" do
      subject.write(Xmlss::Element::Cell.new("line\n\rbreak", :type => :string))
      subject.flush

      assert_equal "<Cell><Data ss:Type=\"String\">line#{Writer::LB}break</Data></Cell>", subject.worksheets_markup.to_s
    end

    should "write cell data markup w/ line breaks and leading space" do
      subject.write(Xmlss::Element::Cell.new(%s{
Should
  honor
    this}, :type => :string))
      subject.flush

      assert_equal(
        "<Cell><Data ss:Type=\"String\">#{Writer::LB}Should#{Writer::LB}  honor#{Writer::LB}    this</Data></Cell>",
        subject.worksheets_markup.to_s
      )
    end

    should "write cell data markup w/ escaped values" do
      subject.write(Xmlss::Element::Cell.new("some\n&<>'\"/\ndata"))
      subject.flush

      assert_equal(
        "<Cell><Data ss:Type=\"String\">some&#13;&#10;&amp;&lt;&gt;&#x27;&quot;&#x2F;&#13;&#10;data</Data></Cell>",
        subject.worksheets_markup.to_s
      )
    end

    should "write worksheet element markup" do
      subject.write(Xmlss::Element::Worksheet.new('awesome'))
      subject.push(:worksheets)

      subject.write(Xmlss::Element::Column.new({
          :width => 120,
          :style_id => 'narrowcolumn'
      }))

      subject.write(Xmlss::Element::Row.new({
        :hidden => true,
        :height => 120,
        :style_id => 'awesome'
      }))
      subject.push(:worksheets)

      subject.write(Xmlss::Element::Cell.new({
        :index => 2,
        :data  => "100",
        :type  => :number,
        :href  => "http://www.google.com"
      }))

      subject.flush

      assert_equal(
        "<Worksheet ss:Name=\"awesome\"><Table><Column ss:StyleID=\"narrowcolumn\" ss:Width=\"120\" /><Row ss:Height=\"120\" ss:Hidden=\"1\" ss:StyleID=\"awesome\"><Cell ss:HRef=\"http://www.google.com\" ss:Index=\"2\"><Data ss:Type=\"Number\">100</Data></Cell></Row></Table></Worksheet>",
        subject.worksheets_markup.to_s
      )
    end

    should "write multiple cells with data in a row" do
      subject.write(Xmlss::Element::Row.new)
      subject.push(:worksheets)

      2.times { subject.write(Xmlss::Element::Cell.new("100")) }
      subject.pop(:worksheets)

      subject.flush

      assert_equal(
        "<Row><Cell><Data ss:Type=\"String\">100</Data></Cell><Cell><Data ss:Type=\"String\">100</Data></Cell></Row>",
        subject.worksheets_markup.to_s
      )
    end

    should "write multiple rows with cells in a worksheet" do
      subject.write(Xmlss::Element::Worksheet.new('two rows'))
      subject.push(:worksheets)

      subject.write(Xmlss::Element::Row.new)
      subject.push(:worksheets)
      subject.write(Xmlss::Element::Cell.new("row1"))
      subject.pop(:worksheets)

      subject.write(Xmlss::Element::Row.new)
      subject.push(:worksheets)
      subject.write(Xmlss::Element::Cell.new("row2"))
      subject.pop(:worksheets)

      subject.pop(:worksheets)
      subject.flush

      assert_equal(
        "<Worksheet ss:Name=\"two rows\"><Table><Row><Cell><Data ss:Type=\"String\">row1</Data></Cell></Row><Row><Cell><Data ss:Type=\"String\">row2</Data></Cell></Row></Table></Worksheet>",
        subject.worksheets_markup.to_s
      )
    end

  end



  class WorkbookWritingTests < BasicTests

    def build_workbook(writer)
      writer.write(Xmlss::Style::Base.new(:some_font))
      writer.push(:styles)
      writer.write(Xmlss::Style::Font.new({:bold => true}))
      writer.pop(:styles)

      writer.write(Xmlss::Style::Base.new(:some_numformat))
      writer.push(:styles)
      writer.write(Xmlss::Style::NumberFormat.new("General"))
      writer.pop(:styles)

      writer.write(Xmlss::Element::Worksheet.new('test1'))
      writer.push(:worksheets)
      writer.write(Xmlss::Element::Row.new({:hidden => true}))
      writer.push(:worksheets)
      writer.write(Xmlss::Element::Cell.new("some data", {:index => 2}))
      writer.pop(:worksheets)
      writer.pop(:worksheets)

      writer.write(Xmlss::Element::Worksheet.new('test2'))
      writer.push(:worksheets)
      writer.write(Xmlss::Element::Row.new({:hidden => true}))
      writer.push(:worksheets)
      writer.write(Xmlss::Element::Cell.new("some data", {:index => 2}))
      writer.pop(:worksheets)
      writer.pop(:worksheets)

      writer.flush
    end

    should "return workbook markup" do
      build_workbook(subject)
      assert_equal(
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"><Styles><Style ss:ID=\"some_font\"><Font ss:Bold=\"1\" /></Style><Style ss:ID=\"some_numformat\"><NumberFormat ss:Format=\"General\" /></Style></Styles><Worksheet ss:Name=\"test1\"><Table><Row ss:Hidden=\"1\"><Cell ss:Index=\"2\"><Data ss:Type=\"String\">some data</Data></Cell></Row></Table></Worksheet><Worksheet ss:Name=\"test2\"><Table><Row ss:Hidden=\"1\"><Cell ss:Index=\"2\"><Data ss:Type=\"String\">some data</Data></Cell></Row></Table></Worksheet></Workbook>",
        subject.workbook
      )
    end

    should "return pretty workbook markup" do
      writer = Writer.new(:pp => 2)
      build_workbook(writer)
      assert_equal(
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\">\n  <Styles>\n    <Style ss:ID=\"some_font\">\n      <Font ss:Bold=\"1\" />\n    </Style>\n    <Style ss:ID=\"some_numformat\">\n      <NumberFormat ss:Format=\"General\" />\n    </Style>\n  </Styles>\n  <Worksheet ss:Name=\"test1\">\n    <Table>\n      <Row ss:Hidden=\"1\">\n        <Cell ss:Index=\"2\">\n          <Data ss:Type=\"String\">some data</Data>\n        </Cell>\n      </Row>\n    </Table>\n  </Worksheet>\n  <Worksheet ss:Name=\"test2\">\n    <Table>\n      <Row ss:Hidden=\"1\">\n        <Cell ss:Index=\"2\">\n          <Data ss:Type=\"String\">some data</Data>\n        </Cell>\n      </Row>\n    </Table>\n  </Worksheet>\n</Workbook>",
        writer.workbook
      )
    end



  end

end
