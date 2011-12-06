require "assert"
require 'xmlss/style/base'

module Xmlss::Style

  class BaseTest < Assert::Context
    desc "Xmlss::Style::Base"
    before { @bs = Base.new(:test) }
    subject { @bs }

    should have_reader :id, :i_d, :border
    should have_accessors :borders, :alignment, :font
    should have_accessors :interior, :number_format, :protection

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
      assert_equal [],  subject.borders
      [ :alignment, :border, :font,
        :interior, :number_format, :protection
      ].each do |s|
        assert_equal nil, subject.send(s)
      end
    end

  end

  class SetAlignmentTest < Assert::Context
    desc "that sets alignment"
    before do
      @s = Base.new(:alignment) do
        alignment(
          :horizontal => :left,
          :vertical => :center,
          :wrap_text => true
        )
      end
    end
    subject { @s }

    should "create an Alignment object" do
      assert_kind_of Alignment, subject.alignment
      assert_equal true, subject.alignment.wrap_text
      assert_equal Alignment.horizontal(:left), subject.alignment.horizontal
      assert_equal Alignment.vertical(:center), subject.alignment.vertical
    end
  end

  class SetBorderTest < Assert::Context
    desc "that sets borders"
    before do
      @s = Base.new(:borders) do
        border(:position => :left)
        border(:position => :right)
      end
    end
    subject { @s }

    should "create Border objects and add them to its borders" do
      assert_equal 2, subject.borders.size
      assert_kind_of Border, subject.borders.first
      assert_equal Border.position(:left), subject.borders.first.position
      assert_equal Border.position(:right), subject.borders.last.position
    end

    should "error if manually setting borders to non ItemSet collection" do
      assert_raises ::ArgumentError do
        subject.borders = []
      end
    end
  end

  class SetFontTest < Assert::Context
    desc "that sets font"
    before { @s = Base.new(:font) { font(:bold => true) } }
    subject { @s }

    should "should create a Font object" do
      assert_kind_of Font, subject.font
      assert subject.font.bold?
    end
  end

  class SetInteriorTest < Assert::Context
    desc "that sets interior"
    before { @s = Base.new(:interior) { interior(:color => "#000000") } }
    subject { @s }

    should "should create an Interior object" do
      assert_kind_of Interior, subject.interior
      assert_equal "#000000", subject.interior.color
    end
  end

  class SetNumberFormatTest < Assert::Context
    desc "that sets number format"
    before { @s = Base.new(:number_format) { number_format(:format => "General") } }
    subject { @s }

    should "should create a NumberFormat object" do
      assert_kind_of NumberFormat, subject.number_format
      assert_equal "General", subject.number_format.format
    end
  end

  class SetProtectionTest < Assert::Context
    desc "that sets protection"
    before { @s = Base.new(:protection) { protection(:protect => true) } }
    subject { @s }

    should "should create a Protection object" do
      assert_kind_of Protection, subject.protection
      assert subject.protection.protected?
    end
  end

  class BaseXmlTest < BaseTest
    desc "for generating XML"

    should have_reader :xml
    should_build_xml
    should_build_no_attributes_by_default(Xmlss::Style::Alignment)
  end

end
