require "test/helper"
require 'xmlss/style/number_format'

class Xmlss::Style::NumberFormatTest < Test::Unit::TestCase

  context "Xmlss::Style::NumberFormat" do
    subject { Xmlss::Style::NumberFormat.new }

    should_have_class_method :format
    {
      :general => "General",
      :general_number => "General Number",
      :general_date => "General Date",
      :long_date => "Long Date",
      :medium_date => "Medium Date",
      :short_date => "Short Date",
      :long_time => "Long Time",
      :medium_time => "Medium Time",
      :short_time => "Short Time",
      :currency => "Currency",
      :euro_currency => "Euro Currency",
      :fixed => "Fixed",
      :standard => "Standard",
      :percent => "Percent",
      :scientific => "Scientific",
      :yes_no => "Yes/No",
      :true_false => "True/False",
      :on_off => "On/Off"
    }.each do |format, value|
      should "provide the value for the '#{format}' format" do
        assert_equal value, Xmlss::Style::NumberFormat.format(format)
      end
    end

    should_have_accessor :format

    context "that sets attributes at init" do
      subject do
        Xmlss::Style::NumberFormat.new({
          :format => :yes_no
        })
      end

      should "should set them correctly" do
        assert_equal "Yes/No", subject.format
      end
    end

    context "that sets format by key" do
      before do
        subject.format = :on_off
      end

      should "should returm it by value" do
        assert_equal "On/Off", subject.format
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
