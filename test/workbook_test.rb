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

      context "when initializing with attrs" do
        subject do
          # specifying attrs at init time
          Workbook.new({
            :worksheets => [Worksheet.new('sheet1')]
          })
        end
        before do
          # writing attrs at run time
          subject.styles = [
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

      context "for generating XML" do
        should_have_reader :xml
        should_build_node
      end
    end

  end
end
