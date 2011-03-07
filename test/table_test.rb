require "test/helper"
require 'xmlss/table'

module Xmlss
  class TableTest < Test::Unit::TestCase

    context "Xmlss::Table" do
      subject { Table.new }

      should_have_accessor :columns, :rows

      should "set it's defaults" do
        assert_equal [], subject.columns
        assert_equal [], subject.rows
      end

      context "for generating XML" do
        should_have_reader :xml
        should_build_node
      end

      context "when using rows/columns" do
        before do
          subject.columns << Column.new
          r = Row.new
          r.cells << Cell.new
          subject.rows << r
        end

        should "should build a table object" do
          puts subject.to_xml
          assert_equal 1, subject.columns.size
          assert_kind_of Column, subject.columns.first
          assert_equal 1, subject.rows.size
          assert_kind_of Row, subject.rows.first
        end
      end

    end

  end
end
