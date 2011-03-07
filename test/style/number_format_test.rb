require "test/helper"
require 'xmlss/style/number_format'

class Xmlss::Style::NumberFormatTest < Test::Unit::TestCase

  context "Xmlss::Style::NumberFormat" do
    subject { Xmlss::Style::NumberFormat.new }

    should_have_accessor :format

    context "that sets attributes at init" do
      subject do
        Xmlss::Style::NumberFormat.new({
          :format => "General"
        })
      end

      should "should set them correctly" do
        assert_equal "General", subject.format
      end
    end

    context "that sets format by key" do
      before do
        subject.format = "@"
      end

      should "should returm it by value" do
        assert_equal "@", subject.format
      end
    end

    context "that sets format by value" do
      before do
        subject.format = "True/False"
      end

      should "should returm it by value" do
        assert_equal "True/False", subject.format
      end
    end

    context "for generating XML" do
      should_have_reader :xml
      should_build_node
      should_build_no_attributes_by_default(Xmlss::Style::Alignment)
    end

  end
end
