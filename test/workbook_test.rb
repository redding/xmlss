require "assert"
require 'xmlss/workbook'

module Xmlss::Worbook

  class BasicTests < Assert::Context
    desc "Xmlss::Workbook"
    before { @wkbk = Xmlss::Workbook.new(Xmlss::Writer.new) }
    subject { @wkbk }

    should have_class_method :writer, :styles_stack, :worksheets_stack
    should have_instance_methods :to_s, :to_file

    should have_instance_methods :style, :alignment, :borders, :border
    should have_instance_methods :font, :interior, :number_format, :protection

    should have_instance_methods :worksheet, :column, :row, :cell

    should have_instance_methods :data, :type
    should have_instance_methods :index, :style_id, :formula, :href
    should have_instance_methods :merge_across, :merge_down, :height
    should have_instance_methods :auto_fit_height, :hidden, :width
    should have_instance_methods :auto_fit_width, :name

    should "return element objs when calling its element methods" do
      assert_kind_of Xmlss::Element::Worksheet, subject.worksheet('test')
      assert_kind_of Xmlss::Element::Column, subject.column
      assert_kind_of Xmlss::Element::Row, subject.row
      assert_kind_of Xmlss::Element::Cell, subject.cell
    end

    should "return style objs when calling its style methods" do
      assert_kind_of Xmlss::Style::Base, subject.style('test')
      assert_kind_of Xmlss::Style::Alignment, subject.alignment
      assert_kind_of Xmlss::Style::Border, subject.border
      assert_kind_of Xmlss::Style::Font, subject.font
      assert_kind_of Xmlss::Style::Interior, subject.interior
      assert_kind_of Xmlss::Style::NumberFormat, subject.number_format
      assert_kind_of Xmlss::Style::Protection, subject.protection
    end

    should "return workbook markup string" do
      assert_match /<Workbook /, subject.to_s
    end

    should "write workbook markup to a file path" do
      path = nil
      assert_nothing_raised do
        path = subject.to_file("./tmp/workbook_test.xls")
      end
      assert_kind_of ::String, path
      assert_equal './tmp/workbook_test.xls', path
      assert File.exists?(path)
    end

    should "maintain the workbook's scope throughout content blocks" do
      wkbk = Xmlss::Workbook.new(Xmlss::Writer.new) do
        style('test') {
          alignment
          borders {
            border
          }
          font
          interior
          number_format
          protection
        }
        worksheet {
          name 'test'
          column

          row {
            cell { data self.object_id }
          }
        }
      end

      assert_equal(
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"><Styles><Style ss:ID=\"test\"><Alignment /><Borders><Border ss:LineStyle=\"Continuous\" ss:Weight=\"1\" /></Borders><Font /><Interior /><NumberFormat /><Protection /></Style></Styles><Worksheet ss:Name=\"test\"><Table><Column /><Row><Cell><Data ss:Type=\"Number\">#{wkbk.object_id}</Data></Cell></Row></Table></Worksheet></Workbook>",
        wkbk.to_s
      )
    end

  end

  class DataTests < BasicTests

    should "bork if non hash-like data is provided" do
      assert_raises NoMethodError do
        Xmlss::Workbook.new(Xmlss::Writer.new, "some data")
      end
      assert_respond_to(
        :some,
        Xmlss::Workbook.new(Xmlss::Writer.new, :some => 'data')
      )
    end

    should "complain if trying to set data that conflict with public methods" do
      assert_raises ArgumentError do
        Xmlss::Workbook.new(Xmlss::Writer.new, :worksheet => "yay!")
      end
    end

    should "respond to each data key with its value" do
      wkbk = Xmlss::Workbook.new(Xmlss::Writer.new, :some => 'data')
      assert_equal "data", wkbk.some
    end

    should "be able to access its data in the workbook definition" do
      wkbk = Xmlss::Workbook.new(Xmlss::Writer.new, :worksheet_name => "awesome") do
        worksheet worksheet_name
      end
      assert_equal(
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"><Styles></Styles><Worksheet ss:Name=\"awesome\"><Table></Table></Worksheet></Workbook>",
        wkbk.to_s
      )
    end

  end

end
