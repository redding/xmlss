require "test/helper"
require 'xmlss/workbook'

module Xmlss
  class WorkbookTest < Test::Unit::TestCase

    context "Xmlss::Workbook" do
      subject { Workbook.new }

      should_have_accessor :styles, :worksheets
      should_have_instance_method :to_xml

      should "set it's defaults" do
        assert_equal [], subject.styles
        assert_equal [], subject.worksheets
      end

      context "for generating XML" do
        should_have_reader :xml
        should_build_node
      end
    end

  end
end
