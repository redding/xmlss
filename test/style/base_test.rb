require "test/helper"
require 'xmlss/style/base'

class Xmlss::Style::BaseTest < Test::Unit::TestCase
  context "Xmlss::Style::Base" do
    subject { Xmlss::Style::Base.new(:test) }

    should_have_reader :id, :i_d, :border
    should_have_accessors :borders, :alignment, :font
    should_have_accessors :interior, :number_format, :protection

    should "bark if you don't init with an id" do
      assert_raises ArgumentError do
        Xmlss::Style::Base.new(nil)
      end
    end

    should "force string ids" do
      assert_equal 'string', Xmlss::Style::Base.new('string').id
      assert_equal 'symbol', Xmlss::Style::Base.new(:symbol).id
      assert_equal '123', Xmlss::Style::Base.new(123).id
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

    context "that sets alignment" do
      subject do
        Xmlss::Style::Base.new(:alignment) do
          alignment(
            :horizontal => :left,
            :vertical => :center,
            :wrap_text => true
          )
        end
      end

      should "should create an Alignment object" do
        assert_kind_of Xmlss::Style::Alignment, subject.alignment
        assert_equal true, subject.alignment.wrap_text
        assert_equal Xmlss::Style::Alignment.horizontal(:left), subject.alignment.horizontal
        assert_equal Xmlss::Style::Alignment.vertical(:center), subject.alignment.vertical
      end
    end

    context "that sets borders" do
      subject do
        Xmlss::Style::Base.new(:borders) do
          border(:position => :left)
          border(:position => :right)
        end
      end

      should "should create Border objects and add them to its borders" do
        puts subject.to_xml
        assert_equal 2, subject.borders.size
        assert_kind_of Xmlss::Style::Border, subject.borders.first
        assert_equal Xmlss::Style::Border.position(:left), subject.borders.first.position
        assert_equal Xmlss::Style::Border.position(:right), subject.borders.last.position
      end

      should "error if manually setting borders to non ItemSet collection" do
        assert_raises ArgumentError do
          subject.borders = []
        end
      end
    end

    context "that sets font" do
      subject do
        Xmlss::Style::Base.new(:font) { font(:bold => true) }
      end

      should "should create a Font object" do
        assert_kind_of Xmlss::Style::Font, subject.font
        assert subject.font.bold?
      end
    end

    context "that sets interior" do
      subject do
        Xmlss::Style::Base.new(:interior) { interior(:color => "#000000") }
      end

      should "should create an Interior object" do
        assert_kind_of Xmlss::Style::Interior, subject.interior
        assert_equal "#000000", subject.interior.color
      end
    end

    context "that sets number format" do
      subject do
        Xmlss::Style::Base.new(:number_format) { number_format(:format => "General") }
      end

      should "should create a NumberFormat object" do
        assert_kind_of Xmlss::Style::NumberFormat, subject.number_format
        assert_equal "General", subject.number_format.format
      end
    end

    context "that sets protection" do
      subject do
        Xmlss::Style::Base.new(:protection) { protection(:protect => true) }
      end

      should "should create a Protection object" do
        assert_kind_of Xmlss::Style::Protection, subject.protection
        assert subject.protection.protected?
      end
    end

    context "for generating XML" do
      should_have_reader :xml
      should_build_node
      should_build_no_attributes_by_default(Xmlss::Style::Alignment)
    end

  end
end