require "test/helper"
require 'xmlss/worksheet'

module Xmlss
  class WorksheetTest < Test::Unit::TestCase

    context "Xmlss::Worksheet" do
      subject { Worksheet.new('sheet') }

      should_have_accessor :name, :table

      should "set it's defaults" do
        assert_equal 'sheet', subject.name
        assert_kind_of Table, subject.table
        assert_equal [], subject.table.columns
        assert_equal [], subject.table.rows
      end

      should "filter name chars" do
        # worksheet name cannot contain: /, \, ?, *, [, ]
        assert_equal "test", Worksheet.new("test/").name
        assert_equal "test", Worksheet.new("tes\\t").name
        assert_equal "test", Worksheet.new("te?st").name
        assert_equal "test", Worksheet.new("t*est").name
        assert_equal "test", Worksheet.new("[te]st").name
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

      context "for generating XML" do
        should_have_reader :xml
        should_build_node
      end

    end

  end
end
