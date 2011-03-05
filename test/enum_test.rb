require "test/helper"
require 'xmlss/enum'
require 'test/thing'

module Xmlss
  class EnumTest < Test::Unit::TestCase

    context "Xmlss::Enum mixin" do
      subject { Thing.new }
      before do
        Thing.send :include, Xmlss::Enum
      end

      should_have_class_method :enum

      context "instance" do
        before do
          Thing.send(:enum, :stuff, {
            :a => "eh",
            :b => "bee",
            :c => "see"
          })
        end

        should_have_class_method :stuff
        should "provide class level access to the enum" do
          assert Thing.send(:class_variable_get, "@@stuff")
          assert_equal 3, Thing.send(:class_variable_get, "@@stuff").size
          assert_equal "eh", Thing.stuff(:a)
        end

        should_have_accessor :stuff

        should "write by key and read by value" do
          subject.stuff = :a
          assert_equal "eh", subject.stuff
        end

        should "write by value and read by value" do
          subject.stuff = "bee"
          assert_equal "bee", subject.stuff
        end

        should "not read by key" do
          subject.stuff = :c
          assert_not_equal :c, subject.stuff
        end

        should "write nil for keys that aren't in the enum" do
          subject.stuff = :bad
          assert_equal nil, subject.stuff
        end

        should "write nil for values that aren't in the enum" do
          subject.stuff = "bady-bad"
          assert_equal nil, subject.stuff
        end

      end
    end

  end
end
