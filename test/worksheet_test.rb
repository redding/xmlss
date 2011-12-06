require "assert"
require 'xmlss/worksheet'

module Xmlss
  class WorksheetTest < Assert::Context
    desc "Xmlss::Worksheet"
    before { @wksht = Worksheet.new('sheet') }
    subject { @wksht }

    should have_accessor :name, :table

    should "set it's defaults" do
      assert_equal 'sheet', subject.name
      assert_kind_of Table, subject.table
      assert_equal [], subject.table.columns
      assert_equal [], subject.table.rows
    end

    should "filter name chars" do
      # worksheet name cannot contain: /, \, :, ;, * or start with '['
      assert_equal "test test", Worksheet.new("test/ test").name
      assert_equal "test test", Worksheet.new("tes\\t test").name
      assert_equal "test test", Worksheet.new("te:st test:").name
      ws = Worksheet.new("te;st ;test")
      assert_equal "test test", ws.name
      ws.name = "t*est test"
      assert_equal "test test", ws.name
      ws.name = "[te]st test"
      assert_equal "te]st test", ws.name
      ws.name = "t[e]st test"
      assert_equal "t[e]st test", ws.name
    end

    should "allow defining a table at init" do
      wksht = Worksheet.new('table', {
        :table => Table.new({
          :columns => [Column.new]
        })
      })

      assert_equal 1, wksht.table.columns.size
      assert_kind_of Column, wksht.table.columns.first
    end

    should "bark when no name is given" do
      assert_raises ArgumentError do
        Worksheet.new(nil)
      end
      assert_raises ArgumentError do
        Worksheet.new("")
      end
    end

    should "bark when setting a table to something other" do
      assert_raises ArgumentError do
        subject.table = "not a table"
      end
    end

  end

  class WorksheetXmlTest < WorksheetTest
    desc "for generating XML"

    should have_reader :xml
    should_build_xml
  end

end
