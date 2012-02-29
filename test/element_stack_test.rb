require 'assert'

require 'xmlss/element_stack'
require 'xmlss/element/cell'
require 'xmlss/writer'

module Xmlss



  class ElementStackTests < Assert::Context

    class TestWriter
      def initialize(io); @io = io; end
      def write(element); @io << "|written: #{element.class.name} #{element.object_id}"; end
      def push(template); @io << "|#{template}:opened"; end
      def pop(template); @io << "|#{template}:closed"; end
    end

    desc "an element stack"
    before do
      @cell1 = Element::Cell.new("1")
      @cell2 = Element::Cell.new("2")
      @es = ElementStack.new(TestWriter.new(@test_io = ''), 'tests')
    end
    subject { @es }

    should have_reader :template
    should have_instance_methods :current, :size, :level, :empty?, :first, :last
    should have_instance_methods :push, :pop, :using

    should "be empty by default" do
      assert_empty subject
    end

    should "know the writer template its driving" do
      assert_equal 'tests', subject.template
    end

  end



  class StackTests < ElementStackTests

    should "push elements onto the stack" do
      assert_nothing_raised do
        subject.push(@cell1)
      end

      assert_equal 1, subject.size
    end

    should "know its level (should be one less than the array's size)" do
      assert_equal 0, subject.level
      subject.push(@cell1)
      assert_equal 1, subject.level
    end

    should "fetch the last item in the array with the current method" do
      subject.push(@cell1)
      subject.push(@cell2)

      assert_same @cell2, subject.current
    end

    should "remove the last item in the array with the pop method" do
      subject.push(@cell1)
      subject.push(@cell2)

      assert_equal 2, subject.size

      elem = subject.pop
      assert_same @cell2, elem
      assert_equal 1, subject.size
    end

  end



  class WriterTests < ElementStackTests
    should "open the current element element when a new element is pushed" do
      expected =  "|written: Xmlss::Element::Cell #{@cell1.object_id}"
      expected += "|#{subject.template}:opened"
      subject.push(@cell1)
      subject.push(@cell2)

      assert_equal expected, @test_io
    end

    should "write the current element if no child element is pushed" do
      subject.push(@cell1)
      subject.push(@cell2)
      subject.pop

      assert_match /\|written: Xmlss::Element::Cell #{@cell2.object_id}$/, @test_io
    end

    should "close an element when its popped" do
      expected =  "|written: Xmlss::Element::Cell #{@cell1.object_id}"
      expected += "|#{subject.template}:opened"
      expected += "|written: Xmlss::Element::Cell #{@cell2.object_id}"
      expected += "|#{subject.template}:closed"
      subject.push(@cell1)
      subject.push(@cell2)
      subject.pop
      subject.pop

      assert_equal expected, @test_io
    end

  end



end
