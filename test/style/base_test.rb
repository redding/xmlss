require "assert"
require 'xmlss/style/base'

module Xmlss::Style

  class BaseTest < Assert::Context
    desc "Xmlss::Style::Base"
    before { @bs = Base.new(:test) }
    subject { @bs }

    should have_class_method :writer
    should have_reader :id, :i_d

    should "know its writer" do
      assert_equal :style, subject.class.writer
    end

    should "bark if you don't init with an id" do
      assert_raises ArgumentError do
        Base.new(nil)
      end
    end

    should "force string ids" do
      assert_equal 'string', Base.new('string').id
      assert_equal 'symbol', Base.new(:symbol).id
      assert_equal '123', Base.new(123).id
    end

    should "set it's defaults" do
      assert_equal 'test', subject.id
    end

  end

end
