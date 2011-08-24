require "assert"

class XmlssTest < Assert::Context
  desc "Xmlss helpers"
  subject { Xmlss }

  should "be provided" do
    assert_respond_to :classify, subject
    assert_respond_to :xmlify, subject
  end

  should "classify underscored strings" do
    assert_nothing_raised do
      subject.send(:classify, 'poo')
    end
    assert_equal "Poo", subject.send(:classify, 'poo')
    assert_equal "MorePoo", subject.send(:classify, 'more_poo')
  end

  should "filter values for use in XML" do
    assert_nothing_raised do
      subject.send(:xmlify, 'poo')
    end

    assert_equal 1, subject.send(:xmlify, true)
    assert_equal nil, subject.send(:xmlify, false)
    assert_equal nil, subject.send(:xmlify, "")
    assert_equal "poo", subject.send(:xmlify, 'poo')
  end

end
