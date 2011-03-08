module Xmlss::Style
  class Alignment
    include Xmlss::Xml
    def xml
      { :node => :alignment,
        :attributes => [:horizontal, :vertical, :wrap_text] }
    end

    include Xmlss::Enum
    enum :horizontal, {
      :automatic => "Automatic",
      :left => "Left",
      :center => "Center",
      :right => "Right"
    }
    enum :vertical, {
      :automatic => "Automatic",
      :top => "Top",
      :center => "Center",
      :bottom => "Bottom"
    }

    attr_accessor :wrap_text

    def initialize(attrs={})
      self.wrap_text = attrs[:wrap_text] || false
      self.horizontal = attrs[:horizontal]
      self.vertical = attrs[:vertical]
    end

    def wrap_text?; !!self.wrap_text; end

  end
end
