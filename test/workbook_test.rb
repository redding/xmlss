require "assert"
require 'xmlss/workbook'

module Xmlss
  class WorkbookTest < Assert::Context
    desc "Xmlss::Workbook"
    before { @wkbk = Workbook.new }
    subject { @wkbk }

    should have_accessor :styles, :worksheets
    should have_instance_method :to_xml

    should "set it's defaults" do
      assert_equal [], subject.styles
      assert_equal [], subject.worksheets
    end

  end

  class WorkbookAttrsTest < Assert::Context
    desc "when initializing with attrs"
    subject { @wkbk }
    before do
      # specifying attrs at init time
      @wkbk = Workbook.new({
        :worksheets => [Worksheet.new('sheet1')]
      })

      # writing attrs at run time
      @wkbk.styles = [
        Xmlss::Style::Base.new('title') do
          alignment({:horizontal => :left})
          font({:size => 14, :bold => true})
        end,

        Xmlss::Style::Base.new('header') do
          alignment({:horizontal => :left})
          font({:bold => true})
          [:top, :right, :bottom, :left].each do |p|
            border({:position => :p})
          end
        end
      ]
    end

    should "build the attrs appropriately" do
      [:worksheets, :styles].each do |thing|
        assert_kind_of ItemSet, subject.send(thing)
      end
      assert_kind_of Worksheet, subject.worksheets.first
      assert_equal 1, subject.worksheets.size

      assert_kind_of Style::Base, subject.styles.first
      assert_equal 2, subject.styles.size
    end

  end

  class WorkbookXmlTest < WorkbookTest
    desc "for generating XML"

    should have_reader :xml
    should_build_node

  end

end
