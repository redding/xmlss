require "assert"
require 'xmlss/workbook'

module Xmlss::Worbook

  class BasicTests < Assert::Context
    desc "Xmlss::Workbook"
    before { @wkbk = Xmlss::Workbook.new }
    subject { @wkbk }

    should have_instance_methods :to_s, :to_file
    should have_instance_methods :worksheet, :column, :row, :cell, :data
    should have_instance_methods :style, :alignment, :borders, :border
    should have_instance_methods :font, :interior, :number_format, :protection

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
      wkbk = Xmlss::Workbook.new do
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
        worksheet('test') {
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

  class OptionsTests < BasicTests

    should "bork if non hash-like data is provided" do
      assert_raises NoMethodError do
        Xmlss::Workbook.new(:data => "some data")
      end
      assert_respond_to(
        :some,
        Xmlss::Workbook.new(:data => {:some => 'data'})
      )
    end

    should "complain if trying to set data that conflict with public methods" do
      assert_raises ArgumentError do
        Xmlss::Workbook.new(:data => {:worksheet => "yay!"})
      end
    end

    should "respond to each data key with its value" do
      wkbk = Xmlss::Workbook.new(:data => {:some => 'data'})
      assert_equal "data", wkbk.some
    end

    should "be able to access its data in the workbook definition" do
      wkbk = Xmlss::Workbook.new(:data => {:name => "awesome"}) do
        worksheet name
      end
      assert_equal(
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"><Styles></Styles><Worksheet ss:Name=\"awesome\"><Table /></Worksheet></Workbook>",
        wkbk.to_s
      )
    end

  end

end
