require "assert"
require 'xmlss/style/base'

class Xmlss::Style::Base

  class UnitTests < Assert::Context
    desc "Xmlss::Style::Base"
    before { @bs = Xmlss::Style::Base.new(:test) }
    subject { @bs }

    should have_class_method :writer
    should have_reader :id

    should "know its writer" do
      assert_equal :style, subject.class.writer
    end

    should "bark if you don't init with an id" do
      assert_raises ArgumentError do
        Xmlss::Style::Base.new(nil)
      end
    end

    should "force string ids" do
      assert_equal 'string', Xmlss::Style::Base.new('string').id
      assert_equal 'symbol', Xmlss::Style::Base.new(:symbol).id
      assert_equal '123',    Xmlss::Style::Base.new(123).id
    end

    should "set it's defaults" do
      assert_equal 'test', subject.id
    end

  end

end
